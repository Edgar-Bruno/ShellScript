#!/bin/bash
#IntranetVindula
#
#  Nesse Shell Script, é executado o processo de instalação e/ou execução 
# da Intranet Vindula.
#
# Versão 1.03 - 07/03/2014
#			  - Alteração caminho para executar o script IntranetVindula
#         	  - Atribuição de variavel para "leitura/download"
#             - Adiçao de expressão regular para dinamismo sobre o nome do arquivo baixado	
#             - Atribuição de variavel para o nome o arquivo
#---------------------------------------------------------------------------
# Versão 1.02 - 28/02/2014
#			  - Homolagação 
#---------------------------------------------------------------------------
# Versão 1.02b - 27/02/2014
#             - Adiçao de expressão regular para dinamismo da autalizaçao de versão	
#             - Adição de opções 		
#			  -	Verificação de pacotes instalados
#			  -	Correção ortografica		
#---------------------------------------------------------------------------
# Versão 1.01a - 26/02/2014
#             - Adição de Layout
#             - Adição de Funções de controle								
#---------------------------------------------------------------------------
# Versão 1.00a - 25/02/2014
#             - A versão so Instalador está desatualizado!											
#---------------------------------------------------------------------------

versaoAtual=1.05

cursorVI(){ sleep 0.25; echo -n "   -"; sleep 0.25; echo -n "> "; }

#Nessa variável, é colocado o endereço eletrônico arquivo IntranetVindula.sh
varHTTP=(ufpr.dl.sourceforge.net/project/vindula/2.0.3/scripts/IntranetVindula.sh)

nomeArquivoB=$( echo "$varHTTP" \
				| sed 's:/:\n|:g' \
				| sed -n '/|/{h;${x;p;};d;};H;${x;p;}'\
				| sed 's:|:.:g' )


installN=$(dpkg -l | grep curl | wc -l)

if [[ $installN -eq 0 ]]; then	

echo "estalar"
sleep 5
	apt-get -y install curl
fi

mensaAlert(){

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

sleep 0.25;

((x++))

((y++))

done

}

estiPrinci(){

	txtT="Intranet Vindula."	
    coRa=42
    coRaB=43

}

layouT(){

clear
	echo -e "\n  \e[40m                              \e[m"
	echo -e "  \e[40m \e[m\e[${coRa}m \e[m\e[40m \e[m\e[${coRaB}${txtSt}m \
${txtT} \e[m\e[40m \e[m\e[${coRaB}m  \e[m\e[40m \e[m\e[${coRaB}m \e[m\e[40m \
\e[m\e[${coRaB}m \e[m\e[40m \e[m" 
	echo -e "  \e[40m                              \e[m"	

}

vertificaDor(){

	estiPrinci
	vercionaDor
	layouT

	echo -e "\n  \e[42;37;1m $validador \a\e[m Último release"

	if [[ $versaoAtual = $validador ]]; then
		
		echo -e "\n  Seu instalador está atualizado\n"
		
		sleep 3

	else

		echo -e "  \e[41;37;1m $versaoAtual \e[m Versão atual\n"

			if [[ -n $vVersao ]];then

				echo -e "   Deseja atualizar a versão \
					\n        do Instalador?\n"
				echo -e "     (\e[1ms\e[m) Sim    (\e[1mn\e[m)  Não\n"

				cursorVI
				
				read opcEsco;

					case "$opcEsco" in

					    s | S )
							atualizaDor
						;;

						n | N )

							clear
							exit 0
						;;

						* )
							local corInfo="41;"
							local mensaInfo="OPÇÃO INVALIDA"
							mensaAlert

							sleep 2
							vertificaDor
						;;
			
					esac
			fi
	fi	

if [[ -z $vVersao ]]; then

echo -e "\n      Aguarde por favor...\n"

sleep 2

cd /opt

./$nomeArquivoB

fi

}

vercionaDor(){

    local versLert=$(curl -s $varHTTP)

    local versConf=$( echo -e "$versLert" \
        | sed -r '/^# Vers/!g' \
        | sed '/^$/d' \
        | sed -n '/\#/{p;q;}' \
        | sed 's/-.*$//'\
        | sed 's/\#.*o /versaoAtual=/' )

        validador=$(echo $versConf \
        	| sed 's/versaoAtual=//' )

		# casting da variavel versConf
		versConfC=$(echo $versConf)


}

atualizaDor(){

	vercionaDor
	
	wget -cq "http://$varHTTP" -O /opt/$nomeArquivoB && chmod +x /opt/$nomeArquivoB

	local linhaVersoa=$(cat $(basename "$0") \
		| sed -n '/^versaoAtual/{=;d;}')

	echo "$(sed ''$linhaVersoa's/.*/'$versConfC'/' < $(basename "$0"))" > $(basename "$0")

	
	if [[ -n $vVersao ]]; then

		local corInfo="42;"
		local mensaInfo="ATUALIZAÇÃO COMPLETA"
		mensaAlert
		sleep 2

		clear
		
		exit 0 

	fi

./$(basename "$0")

exit 0
	
}

MENSAGEM_USO="
Uso: $(basename "$0") ['OPCOES']

OPCOES:

  -a, --ajuda           - Mostra a ajuda.
  -V, --versao          - Mostra a versão do Vindula, habilita atualizações e sai.

"
 clear
        case "$1" in

           -a | --ajuda )
               
                echo -e " $MENSAGEM_USO"
                exit 0
                ;;
           -V | --versao )

				vVersao=90

           		vertificaDor

                exit 0

                ;;

            *)
                if test -n "$1"; then 
                    echo -e "\n A opção [ $1 ] é inválida. \n"
                    exit 0
                fi
                ;;
        esac

 if [[ -f /opt/"$nomeArquivoB" ]]; then 

	vertificaDor

else

	atualizaDor

fi