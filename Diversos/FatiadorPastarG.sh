#!/bin/bash

# O intuíto desse Shell Script é, dividir uma pastar com muitíssimos aquivos em diversas pastas com a quantidade de arquivos definido.
# Os arquivos são da recuperação de arquivos, utilizando o FOREMOST, que tem o seguinte formato "112364.tipo_arquivo"
# Arquivo de Controle: ele conterá a listagem de todos os arquivo contidos na pasta de origem

	# arquivo = SED http://thobias.org/doc/sosed.html
	# sed 's/^.*\///' arquivo -> sosed.html (Aqui retornar tudo que estiver posterior ao caracter "selecionado")


path=$(pwd) 
	# Caminho absoluto da pasta com muitíssimos arquivos

pastaOrigin=$(echo $path | sed 's/^.*\///')
	# Apenas o nome da pasta

pastaDestinoBase=$(echo $path"_"Fatiado)
	# Diretório onde será criado subpastas e,  copiado os arquivos da pasta de original

checkArquivosCP=$(echo $pastaDestinoBase"/"$pastaOrigin"_CP.txt")

if [[ ! -d "$pastaDestinoBase" ]]; then
	# Verifica se a subpasta não exite

	mkdir -pv $pastaDestinoBase # cria a subpasta com o caminho absoluto 
	echo -e "\n Diretório criado :\n $pastaDestinoBase"

fi

if [[ ! -f $checkArquivosCP ]]; then
	# Verifica se o arquivo de controle existe
	
	for f in *; do
		# Este for retorna TUDO que existe no diretório pesquisado
		# Esse comando, trás o nome dos arquivos/diretórios que tenham espaços em branco
		if [[ -f $f ]]; then
			# Apenas arquivos serão inseridos no arquivo de controle
			echo ">>> $f\n" >> $checkArquivosCP
			# O nome do arquivo é escrito com marcadores iniciais para posterior alteração após a cópia do mesmo
		fi
	done
fi


arquivoCPLeitura=$(cat $checkArquivosCP | sed -n '/>>> /p')
 # Aqui é feita a leitura única do arquivo de controle capturando apenas os nomes de arquivos não movidos

dNumero=0
 # Numero final do diretório fatiado

nArquivosMAX=999
 # Limitator de arquivos copiados por pasta

arquivoCP="Null"
 # String com o nome do arquivo

l=1
 # Linha do arquivo de controle aonde o arquivo está

function main()
{
	arquivoCont=0

	while [[ ! -z "$arquivoCP" ]]
		do

			arquivoCP=$(echo -e $arquivoCPLeitura \
						| sed -e ''$l'!d' \
						| sed 's/>>> //' \
						| sed 's/^ \+//')

			# sed -e ''$l'!d' -> Retorna a linha selecionada
			# sed 's/>>> //'  -> "Apaga" os caracteres de controle
			# sed 's/^ \+//'  -> Remove o espaço em branco no final da string

			if [[ ! -d "$pastaDestinoBase/Fatiado_$dNumero" ]]; then
				# Verifica se a subpasta não exite
				mkdir -pv "$pastaDestinoBase/Fatiado_$dNumero"
				#echo -e "\n Diretório criado :\n $pastaDestinoBase"
			else
				if [[ $arquivoCont -eq 0 ]]; then
					arquivoCont=$(ls -l "$pastaDestinoBase/Fatiado_$dNumero" | grep ^- | wc -l)
				fi
			fi

			if [[ $arquivoCont -le $nArquivosMAX ]]; then
				# Comando que retorna a quantidade de arquivos de uma pasta
				if [[ ! -z "$arquivoCP" ]] ; then

					eval $(echo "rsync -avhr --progress $(echo -e "\"$path/$arquivoCP\"") $(echo -e "\"$pastaDestinoBase/Fatiado_$dNumero/$arquivoCP\"")")

					sed -i "s/>>> ${arquivoCP}/\[ OK \] ${arquivoCP}/" $checkArquivosCP

					(( arquivoCont++ ))
				fi
		
			else

				(( dNumero++ ))
				main

			fi

			(( l++ ))
			# Auto increment da variável para a definição da linha a ser lida do arquivo de controle
	done
}

main