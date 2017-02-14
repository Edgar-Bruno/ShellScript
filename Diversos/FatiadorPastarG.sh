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
	# Arquivo que conterá todos os arquivos da pasta | Esse, será subdividido e esvaziado

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
else
	# Verifica se o processamento do arquivo foi concluído
	echo -e "\nVerificando o arquivo de controle... \n"
	
	if [[ -f $(cat $checkArquivosCP | sed '/ -_- Processamento concluído -_- /!d') ]]; then
		echo -e " *** Todos os arquivos foram movidos ***\n"
		exit 0
	fi


fi


dNumero=0
 # Numero final do diretório fatiado

nArquivosMAX=999
 # Limitator de arquivos copiados por pasta


arquivoControleContador=0

function leituraARQ()
{
	# Funcao para verificar e criar subdivisões do arquivo de controle
	
	checkarquivoControleContador=$(echo $pastaDestinoBase"/"$pastaOrigin"_CP_"$arquivoControleContador".txt")
	# Cria caminho completo da subdivisão do primeiro arquivo

	if [[ ! -f $checkarquivoControleContador ]]; then
		
		arquivoCPLeitura=$(cat $checkArquivosCP | sed '1, 999!d')
		 # Recebe do arquivo de controle N linhas a fim de criar o subarquivo de controle

		checkarquivoControleContador=$(echo $pastaDestinoBase"/"$pastaOrigin"_CP_"$arquivoControleContador".txt")
			
		echo "$arquivoCPLeitura" > $checkarquivoControleContador
			recebeSaida=$$

			echo "A Saida ----->>> $recebeSaida"
			echo "______"$recebeSaida"_______"
			# read -p "Press any key to continue... " -n1 -s
			# sed '/^$/d' remove espaços em branco
			# Cria o novo arquivo delimitado

		echo -e "\nCriando aquivo de controle\n$checkarquivoControleContador\n"

		echo -e "Removendo os nomes dos arquivos da listagem principal\n"
		sed -i '1, 999d' $checkArquivosCP
		
		leituraARQ

	else

		echo -e " ---- Arquivo de sub leitura existente \n"
		echo $checkarquivoControleContador

		arquivoCPLeitura=$(cat $checkarquivoControleContador | sed -n '/>>> /p')

		if [[ -z $arquivoCPLeitura ]]; then

			echo " * Leitura sem resultados"
			if [[ ! -z $recebeSaida ]]; then
				echo " * Fim do processamento "
				exit 0
			else
				recebeSaida=''
				(( arquivoControleContador++ ))
				leituraARQ
			fi	
		fi
		
	fi

	# Verifica se o arquivo de controle existe
	# arquivoCPLeitura=$(cat $checkArquivosCP | sed -n '/>>> /p')
 	# Aqui é feita a leitura única do arquivo de controle capturando apenas os nomes de arquivos não movidos
}


function main()
{
	arquivoCont=0
	recebeSaida=''

	if [[ -z $arquivoCP ]]; then
		leituraARQ
		arquivoCP="Null"
		# String com o nome do arquivo
		l=1
		# Linha do arquivo de controle aonde o arquivo está
	fi

	while [[ ! -z $arquivoCP ]]

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
				
			else

				if [[ $arquivoCont -eq 0 ]]; then
					arquivoCont=$(ls -l "$pastaDestinoBase/Fatiado_$dNumero" | grep ^- | wc -l)
					# Comando que retorna a quantidade de arquivos de uma pasta
				fi
			fi

			if [[ $arquivoCont -le $nArquivosMAX ]]; then
				if [[ ! -z "$arquivoCP" ]] ; then
					
					eval $(echo "rsync -avhr --progress $(echo -e "\"$path/$arquivoCP\"") $(echo -e "\"$pastaDestinoBase/Fatiado_$dNumero/$arquivoCP\"")")
					
					sed -i "s/>>> ${arquivoCP}/\[ OK \] ${arquivoCP}/" $checkarquivoControleContador

					(( arquivoCont++ ))
					(( l++ ))
					# Auto increment da variável para a definição da linha a ser lida do arquivo de controle
				fi
		
			else

				(( dNumero++ ))
				
				local saidaWhile=0
				arquivoCP=""

			fi

	done

	if [[ $saidaWhile -eq 0 ]]; then
		main
	fi
}

main
