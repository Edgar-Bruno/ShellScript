#!/bin/bash

# O intuíto desse Shell Script é, dividir uma pasta com muitíssimos aquivos em diversas pastas com a quantidade de arquivos definido.
# Os arquivos são da recuperação de arquivos, utilizando o FOREMOST, que tem o seguinte formato "112364.tipo_arquivo"
# Arquivo de Controle: ele conterá a listagem de todos os arquivo contidos na pasta de origem

	# sed 's/^.*\///' arquivo -> sosed.html (Aqui retornar tudo que estiver posterior ao caracter "selecionado")

	# https://linux.die.net/abs-guide/x15683.html
	# arquivo = SED http://thobias.org/doc/sosed.html
	# http://sed.sourceforge.net/sed1line_pt-BR.html
	# http://terminalroot.com.br/2015/07/30-exemplos-do-comando-sed-com-regex.html

function cursorVI()
{
	sleep 0.15
	echo -n "  -"
	sleep 0.15
	echo -n "> "
	read opc
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

		sleep 0.15

		((x++))

		((y++))

	 done

}

function main()
{
	if [[ -z $dNumero ]]; then

		dNumero=0
		# Numero final do diretório Fragmentado

	fi

	arquivoCont=0
	recebeSaida=

	if [[ -z $arquivoCP ]]; then
		leituraARQ
		arquivoCP="Null"
		# String com o nome do arquivo
		l=1
		# Linha do arquivo de controle aonde o arquivo está
	fi

	while [[ -n $arquivoCP ]]

		do
			arquivoCP=$(echo -e $arquivoCPLeitura | sed -e ''$l'!d;s/>>> //;s/^ \+//')

			# sed -e ''$l'!d' -> Retorna a linha selecionada
			# sed 's/>>> //'  -> "Apaga" os caracteres de controle
			# sed 's/^ \+//'  -> Remove o espaço em branco no final da string

			if [[ ! -d "$pastaDestinoBase/Fragmentado_$dNumero" ]]; then
				# Verifica se a subpasta não exite
				mkdir -pv "$pastaDestinoBase/Fragmentado_$dNumero"
				
			else

				if [[ $arquivoCont -eq 0 ]]; then
					arquivoCont=$(ls -l "$pastaDestinoBase/Fragmentado_$dNumero" | grep ^- | wc -l)
					# Comando que retorna a quantidade de arquivos de uma pasta
				fi
			fi

			if [[ $arquivoCont -le $nArquivosMAX ]]; then
				if [[ -n "$arquivoCP" ]] ; then

					eval "rsync -avhr --progress "\"${!listPaths[0]}/$arquivoCP\"" "\"${!listPaths[1]}/Fragmentado_$dNumero/$arquivoCP\"""
					
					sed -i "s/>>> ${arquivoCP}/\[ OK \] ${arquivoCP}/" "$checkarquivoControleContador"

					# read -p "Press any key to continue... " -n1 -s

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

function leituraARQ()
{
	nArquivosMAX=1014
	# Limitator de arquivos copiados por pasta
	# Funcao para verificar e criar subdivisões do arquivo de controle
	
	checkarquivoControleContador=${!listPaths[1]}"/"$pastaOrigin"_CP_"$arquivoControleContador".txt"
	# Cria caminho completo da subdivisão do primeiro arquivo

	if [[ ! -f $checkarquivoControleContador ]]; then
		
		arquivoCPLeitura=$(cat "$checkArquivosCP" | sed '15, '${nArquivosMAX}'!d')
		 # Recebe do arquivo de controle N linhas a fim de criar o subarquivo de controle

		checkarquivoControleContador=${!listPaths[1]}"/"$pastaOrigin"_CP_"$arquivoControleContador".txt"	

		echo "$arquivoCPLeitura" > "$checkarquivoControleContador"
			recebeSaida=$$

			# sed '/^$/d' remove espaços em branco
			# Cria o novo arquivo delimitado

		echo -e "\n Criando aquivo de controle\n$checkarquivoControleContador\n"

		echo -e " Removendo os nomes dos arquivos da listagem principal\n"
		sed -i '15, '${nArquivosMAX}'d' "$checkArquivosCP"
		
		leituraARQ

	else

		echo -e " ---- Arquivo de sub leitura existente \n"

		arquivoCPLeitura=$(cat "$checkarquivoControleContador" | sed -n '/>>> /p')

		if [[ -z $arquivoCPLeitura ]]; then

			echo " * Leitura sem resultados"
			if [[ -n $recebeSaida ]]; then
				
				varTXT="\n ---------------------------------\
						\n $leiCopy `date +"%H:%M:%S | %Y-%m-%d"`\n\
						\n**********************************"
				 
				sed -i '12s/^/'"$varTXT"'/' $checkArquivosCP

				opc="N"
				auxVerificadorBOeD
				
				rm $checkarquivoControleContador

				cat "$checkArquivosCP"
				exit 0

			else
				recebeSaida=
				(( arquivoControleContador++ ))
				leituraARQ
			fi	
		fi
		
	fi

}

function verificadorBOeD()
{
# Função responsavel por verificar se a execulção do script ocorreu sem erros.
# Há dois marcadores no final desse arquivo
	local varW=

    case "$leituraEscrita"  in
    # Aqui é definido quando os marcadores serão escritos ou apagados
    # = 0 -> Leitura dos Marcadores encontrados
    	0 )
			varW=" - Leitura"

	        local leiORI="$(sed -n '/'${listOD[0]}'/h;${x;p;}' "$pathBasename")"
	        # Imprimir a última ocorrência da linha com determinada string
	        # Recebe os marcadores de backups e seus valores

	        eval "${listOD[0]}='$(sed 's/'${listOD[1]}'.*$//;s/'${listOD[0]}'//;s/^ //;s/ *$//' <<< "$leiORI")'"
	        # Pega o caminho absoluto da origem dos dados
	        
	        eval "${listOD[1]}='$(sed 's/^.*'${listOD[1]}' //' <<< "$leiORI")'"
	        # Pega o caminho absoluto do destino dos dados
	        
	        leituraEscrita=1
		    verificadorBOeD
	    ;;
    	1 )
		    if [[ -d ${!listOD[0]} ]] && [[ -d ${!listOD[1]} ]]; then

		    # Verifica se os caminhos exitem
		    # Mandem os marcadores existente para continuar o processamento
		    	eval "${listPaths[0]}='${!listOD[0]}'"
		        eval "${listPaths[1]}='${!listOD[1]}'"
		        opc=21
		        paran=
		       	varW=" - DIRETORIOS VALIDOS"
		    else
		    # !!! Caso um dos marcadores contem alguma falha, AMBOS SERÃO APAGADOS
		    	if [[ -n ${!listOD[0]} ]];then
			    	eval "${listPaths[0]}="
			    	eval "${listPaths[1]}="
			    	leituraEscrita=2
			    	verificadorBOeD
			    	varW=" - REMOVEDOS"
			    else 
			    	varW=" - NULOS"
		    	fi
		    fi
		;;
		2 )
	   		# != 0|1 -> Escreve ou apaga os marcadores
	        varW="${listOD[0]} ${!listPaths[0]} ${listOD[1]} ${!listPaths[1]}"
	        # String a ser gravado nos marcadores

	        sed -i ':a;$!{N;ba;};s|\(.*\)'${listOD[0]}'.*|\1'"$varW"'|' "$pathBasename"
	        # Substirui a última ocorrencia de string por outra apagando todo o conteúdo da linha

	        if [[ -n ${!listPaths[0]} ]]; then
	        	varW=" - Escritos"
	        else
	        	varW=" - Apagados"
	        fi

		;;
    	* )
		 	varW=" - Mantidos"
        ;;
    esac
	
	echo -e "\n >>>  Marcadores de backups $varW"

}

function auxVerificadorBOeD()
# Metodo para auviliar as opções de leitura e escrita dos marcadores de backups
{
	if [[ -z ${!listOD[0]} ]]; then
		leituraEscrita=2

	elif [[ $opc = "N" ]]; then
		leituraEscrita=1

	else
		leituraEscrita=3
	fi
	
	eval "${listOD[0]}=' _ '"
	verificadorBOeD
	# read -p "Press any key to continue... " -n1 -s
}

function escreveArquivoLeitura()
# Escreve o ArquivoCP com a leitura do diretório especificado em $path
{
	
	arquivoControleContador=0	
	corInfo="42;"

	leiCom="Completed Read:"
	leiCopy="Copy Completed:"

	pastaOrigin=$(sed 's/^.*\///' <<< ${!listPaths[0]})
	# Pega a última string após a \
	# Apenas o nome da pasta

	checkArquivosCP=${!listPaths[1]}"/"$pastaOrigin"_CP.txt"
	# Arquivo que conterá todos os arquivos da pasta | Esse, será subdividido e esvaziado
	
	if [[ ! -f "$checkArquivosCP" ]]; then
		# Verifica se o arquivo de controle existe

		echo -e "*** $(basename "$0") ***\n\
				\n Started Read:   `date +"%H:%M:%S | %Y-%m-%d"`\
				\n ---------------------------------\
				\n Origem  ${!listPaths[0]}\
				\n Destino ${!listPaths[1]}\
				\n --------------------------------- \n\n\n\n" > "$checkArquivosCP"
		# cabeçalho
		
		local x=0
		local y=0
		local z=0

		cd "${!listPaths[0]}"

		for f in *; do
			# Este for retorna TUDO que existe no diretório pesquisado
			# Esse comando, trás o nome dos arquivos/diretórios mesmo contendo espaços em branco e/ou caracteres especiais
			if [[ -f $f ]]; then
				# Apenas arquivos serão inseridos no arquivo de controle

				echo ">>> $f\n" >> "$checkArquivosCP"
				# O nome do arquivo é escrito com marcadores iniciais para posterior alteração após a cópia do mesmo
				#----
				if [[ x -le 125 ]]; then	
	
			        coAle="41;"
			      
			    elif [[ x -ge 126 ]] && [[ x -le 250 ]]; then

			        coAle="40;"

			    else

			    	x=0
			    fi

			    if [[ y -le 250 ]]; then	
	
			        mensaInfo="  Aguarde...  "
			      
			    elif [[ y -ge 251 ]] && [[ y -le 500 ]]; then

			        mensaInfo="Lendo diretório..."
			    else

			    	y=0
			    fi

				echo -ne "  \e[${coAle}37;1m       $mensaInfo       \e[m\r"

				((x++))
				((y++))
				((z++))

			fi
		done

		varTXT="\n $leiCom `date +"%H:%M:%S | %Y-%m-%d"`\
				 \n --------------------------------- \
				 \n Total de arquivos: $z"

		sed -i '8s/^/'"$varTXT"'/' $checkArquivosCP

		mensaInfo="Leitura completa..."
		cd -

	else

		mensaInfo="Verificando o arquivo de controle..."
		
		if [[ -z $(sed -n '/'"$leiCom"'/p' "$checkArquivosCP") ]];then
			echo "O arquivo de leitura, ainda precisa ser finalizado corretamente"
			
			rm $checkArquivosCP
			vaux="v"
			escreveArquivoLeitura

		elif [[ -z $(sed -n '/'"$leiCopy"'/p' "$checkArquivosCP") ]]; then
			
			echo -e "\n"
			mensaInfo="Todos os arquivos listados foram movidos"
	
		else
			echo "O arquivo de leitura, foi finalizado corretamente"
		fi
	fi
	mensaAlert
	main
}

function criarDiretorios()
{
	if [[ $criarDire -eq 0 ]]; then
		# --------- Caso o script tenha sido executado sem parametros
		if [[ ! -d "${!listPaths[1]}" ]]; then
			# Verifica se a subpasta não exite
			mkdir -pv "${!listPaths[1]}" # cria a subpasta com o caminho absoluto 
			# Esse comando cria o diretórimo mesmo com espaços em branco
		fi

	else

		local varDIR=

		if [[ cancelVAR -eq 0 ]]; then

			echo -e "\n Agora, digite o caminho absoluto do destino para a fragmentação da pasta\
					 \n \e[1m $path \e[m \n"
		else

			echo -e "\e[1m $varDIR \e[m \
					 \n Digite um caminho valido."
		fi

		echo -e  "\n Para interromper, digite CANCELAR"
										
		cursorVI

		varDIR=$opc

		if [[ $opc = "CANCELAR" ]]; then
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
			echo -e "\n  A pasta \e[1m $varDIR \e[m \
			 	     \n não existe. Deseja cria-la?.\
					 \n [C] - Confirmar | $opcT"
				
			cursorVI
				
			if [[ $opc = "C" ]]; then

			mkdir -pv "$varDIR"

				if [[ $? -eq 0 ]]; then
					echo -e "\n Pasta criada. \n"
					eval "${listPaths[1]}=$varDIR"
					vaux=0
					
				else
					
					opc=
					((cancelVAR++))

					echo -e "\n Não foi possivel criar a pasta. Verifique o endereço de destino."

					if [[ cancelVAR -eq 3 ]]; then
						echo -e " Número de tentativas excedido.\
								\n Verifique se o caminho absoluto está correto e,\
								\n tente mais tarde.\n"
						definirDiretórios
					fi

					criarDiretorios
				fi
			else
			# Cancela a operação
				 echo -e "\n Cancelado pelo usuário"
				 cancelVAR=5
				 vaux=3
			fi
		fi

		if [[ vaux -eq 0 ]]; then

			vaux=
			cancelVAR=
			paran=
		fi

		definirDiretórios
	fi
}

function definirDiretórios()
# Função responsavel por definir os diretórios de origem e destino
{
	local opcT="Precione qualquer tecla para cancelar."

	if [[ -z $cancelVAR ]]; then
		# Controle de recursividade
		clear
		
		mensaAlert

		if [[ -z $paran ]]; then
		# Executado sem passagem de parametros	

			if [[ -z $opc ]]; then

			    eval "${listPaths[0]}=$(pwd)"
			    # Caminho absoluto da pasta com muitíssimos arquivos

				eval "${listPaths[1]}=${!listPaths[0]}\"_Fragmentado\""
				# pastaDestinoBase="/media/user/ArquivosR/Recuperados/mp3/mp3_Fragmentado"
				# Diretório onde será criado subpastas e,  copiado os arquivos da pasta de original
		    
				echo -e "\n  A pasta a ser dividida é onde o \e[1m$(basename "$0")\e[m \
					 \n está em execução;"

			elif [[ $opc = "21" ]]; then
				# Caso os marcadores estejam preenchidos e validos
				echo -e "\n A última execução do \e[1m$(basename "$0")\e[m foi terminada \
						 \n inesperadamente. \
						 \n Deseja que o script continue de onde parou?"

			else
				# Pastas definidas manualmente
				echo -e "\n  Foram especificadas as seguintes pastas;"

		    fi

		    echo -e "\n origem  \e[1m ${!listPaths[0]} \e[m\
					 \n destino \e[1m ${!listPaths[1]} \e[m\
					 \n Os caminhos estão corretos?"

			if [[ $opc = "21" ]];then

				echo -e "\n [C] - Confirmar | [N] - Não | $opcT"

			else

				echo -e "\n [C] - Confirmar | $opcT"
				# Cria diretório quando é executado o script sem passar paramentos
			fi

		else
			echo -e "\n  Escolha a opção para especificar o caminho absoluto da pasta \
					 \n a ser dividida e caminho absoluto da pasta de destino dos arquivos. \
					 \n [D] - Definir | $opcT"

		fi

		cursorVI

	fi

	if [[ $opc = "C" ]]; then
	   	
	   	if [[ $criarDire -eq 0 ]];then
	   		echo "Verifica existencia da pasta de destino"
	   		criarDiretorios
	   		# Regra para escrever os marcaodres dos Barquivo novo ou mantelo
	   	fi

	    auxVerificadorBOeD
	    escreveArquivoLeitura

	elif [[ $opc = "D" ]] && [[ $paran =  "True" ]]; then

		eval "${listPaths[0]}=$(pwd)"
		# Caminho absoluto da pasta com muitíssimos arquivos
		echo -e "\n  A pasta a ser dividida é onde o \e[1m$(basename "$0")\e[m \
				 \n está em execução? \n \
				 \n \e[1m ${!listPaths[0]} \e[m \n \
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
						eval "${listPaths[0]}='$opc'"
						echo -e "\n  A pasta \e[1m ${!listPaths[0]} \e[m \
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
				fi
			done

			if [[ vaux -eq 0 ]]; then
				vaux=
				cancelVAR=0
				criarDiretorios
			fi

		else
		# Caso a reposta seja SIM	
			criarDiretorios
		fi

	else
		# Regra para apagar os registros dos marcadores de endereços
		auxVerificadorBOeD
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
				paran="True"
				sleep 0.25
				echo "Definir diretórios selecionada"
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
	criarDire=0
	corInfo="41;"
	mensaInfo="!!! ATENÇÃO !!!"
else
	criarDire=1
	corInfo="42;"
	mensaInfo="!!! Defina os diretórios !!!"
fi

pathBasename=$(readlink -f ${BASH_SOURCE[0]})
# Pega o endereço de onde o Shellscript está.

# ARRAY
listOD=(Borigem Bdestin)
# Marcadores dos backups dos endereços de Origem e Destino mais os seus respectivos valores

listPaths=(pastaOriginBase pastaDestinoBase)
# Lista das variável do diretórios principais.

leituraEscrita=0
verificadorBOeD
definirDiretórios

exit 0
# Marcadore de backups dos diretórios, caso, a leitura do diretório pesquisa tenha sido interrompida antes de concluír o arquivo de controle.
# Chamado em diversos momentos da execução do script

Borigem  Bdestin 