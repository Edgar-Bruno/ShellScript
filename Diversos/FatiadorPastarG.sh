#!/bin/bash

# O intuíto desse Shell Script é, dividir uma pasta com muitíssimos aquivos em diversas pastas com a quantidade de arquivos definido.
# Os arquivos são da recuperação de arquivos, utilizando o FOREMOST, que tem o seguinte formato "112364.tipo_arquivo"
# Arquivo de Controle: ele conterá a listagem de todos os arquivo contidos na pasta de origem

	# arquivo = SED http://thobias.org/doc/sosed.html
	# sed 's/^.*\///' arquivo -> sosed.html (Aqui retornar tudo que estiver posterior ao caracter "selecionado")

function cursorVI()
{
	sleep 0.25
	echo -n "  -"
	sleep 0.25
	echo -n "> "
	read opc
}

function montarDiretorios()
{

	checkArquivosCP=$(echo $pastaDestinoBase"/"$pastaOrigin"_CP.txt")
		# Arquivo que conterá todos os arquivos da pasta | Esse, será subdividido e esvaziado

	if [[ ! -d "$pastaDestinoBase" ]]; then
		# Verifica se a subpasta não exite

		mkdir -pv "$pastaDestinoBase" # cria a subpasta com o caminho absoluto 
		# Esse comando cria o diretórimo mesmo com espaços em branco
		
	fi

	if [[ ! -f "$checkArquivosCP" ]]; then
		# Verifica se o arquivo de controle existe	
		cd "$path"
		for f in *; do
			# Este for retorna TUDO que existe no diretório pesquisado
			# Esse comando, trás o nome dos arquivos/diretórios mesmo contendo espaços em branco e/ou caracteres especiais
			if [[ -f $f ]]; then
				# Apenas arquivos serão inseridos no arquivo de controle

				echo ">>> $f\n" >> "$checkArquivosCP"
				# O nome do arquivo é escrito com marcadores iniciais para posterior alteração após a cópia do mesmo
		
			fi
		done
		cd -
	else
		# Verifica se o processamento do arquivo foi concluído
		echo -e "\nVerificando o arquivo de controle... \n"
		
		if [[ -f $(cat "$checkArquivosCP" | sed '/ -_- Processamento concluído -_- /!d') ]]; then
			echo -e " *** Todos os arquivos foram movidos ***\n"
			exit 0
		fi

	fi


	dNumero=0
	 # Numero final do diretório fatiado

	nArquivosMAX=999
	 # Limitator de arquivos copiados por pasta

	arquivoControleContador=0

	main
}

function leituraARQ()
{
	# Funcao para verificar e criar subdivisões do arquivo de controle
	
	checkarquivoControleContador=$(echo $pastaDestinoBase"/"$pastaOrigin"_CP_"$arquivoControleContador".txt")
	# Cria caminho completo da subdivisão do primeiro arquivo

	if [[ ! -f $checkarquivoControleContador ]]; then
		
		arquivoCPLeitura=$(cat "$checkArquivosCP" | sed '1, '${nArquivosMAX}'!d')
		 # Recebe do arquivo de controle N linhas a fim de criar o subarquivo de controle

		checkarquivoControleContador=$(echo $pastaDestinoBase"/"$pastaOrigin"_CP_"$arquivoControleContador".txt")
			
		echo "$arquivoCPLeitura" > "$checkarquivoControleContador"
			recebeSaida=$$

			# sed '/^$/d' remove espaços em branco
			# Cria o novo arquivo delimitado

		echo -e "\nCriando aquivo de controle\n$checkarquivoControleContador\n"

		echo -e "Removendo os nomes dos arquivos da listagem principal\n"
		sed -i '1, '${nArquivosMAX}'d' "$checkArquivosCP"
		
		#read -p "Press any key to continue... " -n1 -s
		
		leituraARQ

	else

		echo -e " ---- Arquivo de sub leitura existente \n"

		arquivoCPLeitura=$(cat "$checkarquivoControleContador" | sed -n '/>>> /p')

		if [[ -z $arquivoCPLeitura ]]; then

			echo " * Leitura sem resultados"
			if [[ ! -z $recebeSaida ]]; then
				echo " * Fim do processamento "
				exit 0
			else
				recebeSaida=
				(( arquivoControleContador++ ))
				leituraARQ
			fi	
		fi
		
	fi

}

function mensaAlert()
{

	local y=""
	local x=""

	while [[ y -lt 6 ]]; do

	    if [[ x -gt 1 ]]; then
	        x=0
	        coAle="40;"
	    else
	        coAle="$corInfo"
	    fi
	    
	echo -ne "  \e[${coAle}37;1m       $mensaInfo       \e[m\r"

	sleep 0.25

	((x++))

	((y++))

	 done

}


function main()
{
	arquivoCont=0
	recebeSaida=

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
					
					sed -i "s/>>> ${arquivoCP}/\[ OK \] ${arquivoCP}/" "$checkarquivoControleContador"

					#read -p "Press any key to continue... " -n1 -s

					(( arquivoCont++ ))
					(( l++ ))
					# Auto increment da variável para a definição da linha a ser lida do arquivo de controle
				fi
		
			else

				(( dNumero++ ))
				
				local saidaWhile=0
				arquivoCP=

			fi

	done

	if [[ $saidaWhile -eq 0 ]]; then
		main
	fi
}

function criarDiretorios()
{
	local varDIR=
	cancelVAR=0

	echo -e "\n Agora, digite o caminho absoluto do destino para a fragmentação da pasta\
			 \n \e[1m $path \e[m \n \
			 \n Para interromper, digite CANCELAR"
									
	cursorVI

	varDIR=$opc

	if [[  $opc = "CANCELAR" ]]; then
			cancelVAR=5
			definirDiretórios
	
	elif [[ -d "$opc" ]]; then
	# Verifica se a pasta é existente
	# Altera para o novo caminho absoluto
		pastaDestinoBase=$varDIR
		echo -e "\n  A pasta \e[1m $path \e[m \
				 \n é existente.\
				 \n -------------------------------"
		vaux=0
	else
	# Pasta inexistente 
	
		while [[ cancelVAR -lt 3 ]]; do
			echo -e "\n  A pasta \e[1m $varDIR \e[m \
			  	     \n não existe. Deseja cria-la?.\
					 \n [C] - Confirmar | Precione qualquer tecla para cancelar."
			
			cursorVI
			
			if [[ $opc = "C" ]]; then

				mkdir -pv "$varDIR"

				if [[ $? -eq 0 ]]; then
					echo -e "\n Pasta criada. \n"
					pastaDestinoBase="$varDIR"
					vaux=0
					break
				else
					((cancelVAR++))
					echo -e "\n Não foi possivel criar a pasta. Tente outo endereço.\n"
					if [[ cancelVAR -eq 3 ]]; then
						echo -e " Número de tentativas excedido.\
								\n Verifique se o caminho absoluto está correto e,\
								\n tente mais tarde.\n"
						definirDiretórios
					fi
				fi
			else
			# Cancela a operação
			 echo "Cancelado pelo usuário"
			 cancelVAR=5
			 vaux="x"

			fi
		done

	fi

	if [[ vaux -eq 0 ]]; then

		vaux=
		cancelVAR=
		paran=
		definirDiretórios
	else

		definirDiretórios
	fi

}

function definirDiretórios()
# Função responsavel por definir os diretórios de origem e destino
{

	if [[ -z $cancelVAR ]]; then
		# Controle de recurcividade
		clear
		
		mensaAlert

		if [[ -z $paran ]]; then

			if [[ -z $opc ]]; then

			    path=$(pwd)
			    # Caminho absoluto da pasta com muitíssimos arquivos

				pastaDestinoBase=$(echo $path"_"Fatiado)
				# pastaDestinoBase=$(echo "/media/user/ArquivosR/Recuperados/mp3/mp3_"Fatiado)
				# Diretório onde será criado subpastas e,  copiado os arquivos da pasta de original
		    
				echo -e "\n  A pasta a ser dividida é onde o\e[1m $(basename "$0")\e[m \
					 \n está em execução;"
			else

				echo -e "\n  Foram especificadas as seguintes pastas;"

		    fi

			pastaOrigin=$(echo $path | sed 's/^.*\///')
			# Apenas o nome da pasta
		    
		    echo -e "\n origem  \e[1m $path \e[m\
					 \n destino \e[1m $pastaDestinoBase \e[m \n \
					 \n Os caminhos estão corretos?\
					 \n [C] - Confirmar | Precione qualquer tecla para cancelar."

		else

			echo -e "\n  Escolha a opção para especificar o caminho absoluto da pasta \
					 \n a ser dividida e caminho absoluto da pasta de destino dos arquivos. \
					 \n [D] - Definir | Precione qualquer tecla para cancelar."

		fi

		cursorVI

	fi

	if [[ $opc = "C" ]]; then
	   
	    montarDiretorios

	elif [[ $opc = "D" ]] && [[ $paran =  "True" ]]; then

		path=$(pwd)
		# Caminho absoluto da pasta com muitíssimos arquivos
		echo -e "\n  A pasta a ser dividida é onde o\e[1m $(basename "$0")\e[m \
				 \n está em execução? \n \
				 \n \e[1m $path \e[m \n \
				 \n [S] - Sim | [N] - Não | Precione qualquer tecla para cancelar."

		cursorVI

		if [[ $opc = "N" ]]; then
			# Condição para alterar o diretório da pasta a ser dividida
			cancelVAR=0

			echo -e "\n Digite o caminho absoluto da pasta a ser dividida.\
					 \n Para interromper, digite CANCELAR"

			while [[ cancelVAR -lt 3 ]]; do
								
				cursorVI

				if [[  $opc = "CANCELAR" ]]; then
					cancelVAR=5
					definirDiretórios
					
				else
		
					if [[ -d "$opc" ]]; then
					# Verifica se a pasta é existente
					# Altera para o novo caminho absoluto
						path=$opc
						echo -e "\n  A pasta \e[1m $path \e[m \
								 \n é existente."
						vaux=0
						break 
						
					else
						# Pasta inexistente 
						echo -e "\n  A pasta \e[1m $opc \e[m \
								 \n não existe."
						((cancelVAR++))
						# Limitador de tentativa para inserir um diretório válido

						if [[ cancelVAR -eq 3 ]]; then
							echo -e " Número de tentativas excedido.\
								   \n Verifique se o caminho absoluto está correto e,\
								   \n tente mais tarde.\n"
							definirDiretórios
						fi
					fi

					echo "\n -------------------------------"
				fi

			done

			if [[ vaux -eq 0 ]]; then
				vaux=
				criarDiretorios
			fi

		else
		# Caso a reposta seja SIM	
			echo "SIM é essa pasta aí!"
			criarDiretorios
		fi

	else

	   	echo -e " Operação cancelada. Nenhum arquivo ou pasta foi modificado. \n"
	fi

	exit 0

}

MENSAGEM_USO="
Uso: $(basename "$0") ['OPCOES']

OPÇÕES:

Esse Shell Script é, dividir uma pasta com muitíssimos aquivos\
em, diversas pastas com a quantidade de arquivos pré-definidos.

\e[1m
  -h, --help            - Mostra a ajuda de utilização
  -p, --path            - Definir diretórios de origem e destino
\e[m
"
        case "$1" in

           -h | --help )

                clear
                echo -e " $MENSAGEM_USO"

                exit 0
                ;;

           -p | --path )
				echo "Definir diretórios selecionada"
				paran="True"
				sleep 0.25
				#definirDiretórios
                #exit 0
                ;;

            *)
                if test -n "$1"; then 
                    echo -e "\n A opção [ $1 ] é inválida. \n"
                    exit 0
                fi
                ;;
        esac

if [[ -z $1 ]]; then
	corInfo="41;"
	mensaInfo="!!! ATENÇÃO !!!"
else
	corInfo="42;"
	mensaInfo="!!! Defina os diretórios !!!"

fi

definirDiretórios