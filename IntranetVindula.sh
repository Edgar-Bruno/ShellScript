#!/bin/bash
#
#IntranetVindula
#
# Instala todos os requisitos necessários da intranet Vindula
# Executa a instancia da intranet / Status, Start e Stop
#
#---------------------------------------------------------------------------
# Versão 1.09 - 27/04/2014
#             - Atribuido para Ubuntu 14.04 Server 64bits
#---------------------------------------------------------------------------
# Versão 1.08a - 21/04/2014
#             - Adição de opção a base de dados Vindula(Apenas reinstação) 
#             - Bugfix
#---------------------------------------------------------------------------
# Versão 1.07a - 16/04/2014
#             - Atualização do tar.gz
#---------------------------------------------------------------------------
# Versão 1.07 - 14/03/2014
#             - Bugfix - Menu principal
#---------------------------------------------------------------------------
# Versão 1.06 - 07/03/2014
#             - Redefinição do Layout(cores, formatação, texto e mensagems de alerta)
#             - Case sensitive das opção
#             - Alteração do diretório do arquivo IntranetVindula.sh
#             - Adição de opções. Status e Stop da Intranet
#             - Inclusão do verificador de dependencias instaladas
#             - Bugfix - Start | Status | Stop 
#---------------------------------------------------------------------------
# Versão 1.05 - 28/02/2014
#             - Homolagação 
#---------------------------------------------------------------------------
# Versão 1.05b - 25/02/2014
#             - Inclusão da função de verificação da intraface de rede
#             - Bugfix do layout
#             - Restrição de arquitetura para 12.04 Server 64bits
#             - Inclusão de mensagens  
#---------------------------------------------------------------------------
# Versão 1.04b - 24/02/2014
#             - Melhorias nas ERs
#             - Criação do usuário vindula
#             - Executar a intranet com esse usuário
#---------------------------------------------------------------------------
# Versão 1.03a - 21/02/2014
#             - Identificação do sistem operacional UNIX (server | desktop)
#---------------------------------------------------------------------------
# Versão 1.02a - 19/02/2014
#             - Acerto na criação dos diretórios
#             - Adicionado as opções:
#             --------- Ajuda 
#             --------- Versão  do Instalador
#             --------- Instalar / Recuperar instalação
#---------------------------------------------------------------------------
# Versão 1.01a - 16/02/2014
#             - Inclusão de cabaçalho 
#             - Adicionado suporte comandos por linha de comando e resoluçao de permissionamento.
#---------------------------------------------------------------------------
# Versão 1.00a - 05/02/2014
#             - Não há funções, opções e layout
#---------------------------------------------------------------------------

cursorVI(){ sleep 0.25; echo -n "   -"; sleep 0.25; echo -n "> "; }

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

sleep 0.25

((x++))

((y++))

 done

}

verificaIP(){

    interfaceCon="wlan eth"
        
    local semIpValido=0

for conect in $interfaceCon; do

local ipValido=$(ip addr \
    | grep inet \
    | grep $conect \
    | awk -F" " '{print $2}'\
    | sed 's/\/.*$//')
    
    if [[ -n $ipValido ]]; then

    echo -e " Interface de rede $conect:
 Acesse a Intranet Vindula em sua rede interna
 através desse endereço \e[1m$ipValido:8080/vindula\e[m\n"

    local semIpValido=5
    
    fi

done

    if [[ $semIpValido -eq 0 ]]; then

     echo -e "\n  Para acessar a intranet através de sua
 rede interna, você deve obter um \e[1mip válido\e[m.
 Por favor, verifique as configurações
 de rede\n";

    fi

}

verificador(){

local sisOp=$(cat /etc/apt/sources.list \
    | sed -n 's:[^[]*\(\[[^]]*\]\)[^[]*:\1:gp'\
    | sed 's:(.*)::'\
    | sed -n 1p)


local archteturaSio=$(arch)

requiDiver=0

local contador=0

local requisMin="Ubuntu $releaV Server"

for validaVer in $requisMin; do

    local confVers=$(echo "$sisOp" \
    | sed -e 's:\('$validaVer'\):(\1):g' \
    | sed -n 's:[^()]*\(([^)]*)\)[^(]*:\1:gp')

if [[ $confVers = "($releaV)" ]] && [[ $varPass -eq 1 ]]; then

    varPassB=" "
   
else

    if [[ $varPass -eq 1 ]]; then

        if [[ -z $releaV ]] && [[ -z $varPassB ]]; then
            
            releaV=12.04
            varPass=0
            verificador
            break
    
        elif [[ $releaV = "12.04" ]] && [[ -z $varPassB ]]; then
            
            releaV="14.04"
            varPass=0
            verificador
            break
        
        else

            varPassB="X"

        fi    
    fi

fi

((varPass++))

        if [[ -n $confVers ]]; then

            echo -e "  \e[42;37;1m OK \e[m $validaVer"

        else

            if [[ -z $confVers ]] && [[ $requiDiver -eq 0 ]]; then

                if [[ $contador -eq 1 ]]; then
               
                    UbuntuDife=1

                else    

                    UbuntuServer=1

                fi  

            ((requiDiver++))    

            if [[  varPassB = "X" ]]; then
                lsb_release -d 
            fi    
            echo -e "  \e[41;37;1m NO \e[m $validaVer"

            else

            ((requiDiver++))

            fi  

        fi

((contador++))

 done

if [[ $archteturaSio = x86_64 ]]; then

    echo -e "  \e[42;37;1m OK \e[m 64bits ";

else

    echo -e "  \e[41;37;1m NO \e[m 64bits ";

    ((requiDiver++))
fi

}

verificadorMsn(){

if [[ $requiDiver -ne 0 ]] ; then
    clear
    local corInfo="41;"
    echo -e "\n"

    local mensaInfo="!!! INSTALAÇÃO INTERROMPIDA !!!"
    mensaAlert

    echo -e "\n"

    verificador

    echo -e "\n  A instalação da Intranet Vindula será cancelada.\n\
    \n   As configurações do servidor não atendem aos\
    \n   requisitos necessários. Para maiores informações\
    \n   acesse. \e[1m http://www.vindula.com.br\e[m \n" 

    exit 0

else

    confirmarInt

    verificador

    echo -e "\e[0m\n  O seu sistema, atende aos requisitos\
    \n  necessários para a instalação e\
    \n  execução da \e[1mIntranet Vindula.\e[m\n"

    confirmarIntOPC
fi  
}

menuPrincipal(){

clear


if [[ -f /opt/intranet/app/intranet/vindula/bin/instance ]]; then

    checkDB
    clear

    txtLb="                                 "
    txtT="Status do Vindula   "

    if [[ -n $status ]]; then

        txtLb=" [1] - Encerrar execução         " 
        varVl=400
        verificaIP

    else

        if [[ -z $validaRece ]]; then

            txtLb=" [1] - Iniciar a Intranet        "
            varVl=300
          
        fi
    fi

else

    txtT="Instalador do Vindula   "
    txtLb=" [1] - Instalar a Intranet       " 
    varVl=200

    estiInst
 
fi

estiApro  

baseLayout  

if [[ $varVl -ne 200 ]]; then

    verificadorINSTACIA

fi    

cursorVI

read opcD

echo -e "\a"

if [[ $opcD = fgmX ]] ; then

    clear  
    i=3
    varRecur=" "
    executorInstancia
       
else    

    if [[ $opcD = 0 ]]; then

        opcE=100

    else

         if (echo $opcD | egrep '[^0-9]' &> /dev/null)

        then

            opcE=x

        else

            opcE=$(($varVl-$opcD))

        fi

    fi  
fi

case "$opcE" in


    100 )

        estiSair
        ;;

    199 )

        clear
        verificador
        verificadorMsn
        ;;

    299 )

        i=0
        aguardIni
        ;;

    399 )

        i=2
        status=""
        encerrarInstancia
        exit 0
        ;; 

    * )
        opcInvalida
        menuPrincipal
        ;;
esac

opcE=""

}

instalarVindula(){

useradd vindula

apt-get update

apt-get dist-upgrade

add-apt-repository ppa:libreoffice/ppa 

apt-get -y install mysql-client mysql-server

apt-get -y install curl

local vindulaD=`curl -s https://raw2.github.com/vindula/buildout.python/master/dependencias.txt`

for inst in $vindulaD; do 

    local installN=$(dpkg -l | grep $inst | wc -l)

    if [[ $installN -eq 0 ]]; then  

        echo -ne "`apt-get -y install $inst`\r"

    else

        echo -e " $inst - Instalado."

    fi

done

gem install bundle 

gem install docsplit -v 0.6.4

mkdir -pv /opt/core /opt/intranet/app/intranet

git clone https://github.com/vindula/buildout.python.git /opt/core/python

cd /opt/core/python/

python bootstrap.py

easy_install -U distribute

./bin/buildout -vN

/opt/core/python/bin/virtualenv-2.7 --no-site-packages /opt/intranet/app/intranet/

wget -c -P /opt/intranet/app/intranet/ \
"http://downloads.sourceforge.net/project/vindula/2.0.3/Vindula-2.0.3LTS.tar.gz"

tar xvf /opt/intranet/app/intranet/Vindula-2.0.3LTS.tar.gz -C /opt/intranet/app/intranet/

cd /opt/intranet/app/intranet/vindula/

../bin/easy_install -U distribute

../bin/easy_install -U setuptools

../bin/python bootstrap.py

./bin/buildout -vN

chown -R vindula:vindula /opt/intranet/

}

encerrarInstancia(){

cd /

echo "`$varInstancia ${vetStausInst[i]}`"

sleep 2

verificadorINSTACIA

exit 0

}

checkDB(){

    local installN=$(dpkg -l | grep mysql-server | wc -l)

    if [[ $installN -eq 0 ]]; then 

        echo -e "\n Seu sistema não está com o MySQL instalado.\n"
        sleep 2

    else
        
        if [[ -z $checkDBpass ]]; then

            mysql -uvindula -pvindula  -e exit 2> /dev/null

            varMy=$?

        fi

        if [[ $varMy -eq 0 ]]; then

            local dbA=$(mysql -uvindula -pvindula  -e "SHOW DATABASES LIKE 'vindula_myvindulaDB'")
            local dbB=$(mysql -uvindula -pvindula  -e "SHOW DATABASES LIKE 'vindula_relstorageDB'")
                     
            echo -e "\n"

            if [[ -n $dbA ]] && [[ -n $dbB ]] && [[ -z $checkDBpass ]]; then

                local mensaInfo=" *** ATENÇÃO *** "
                local corInfo="44;"
                mensaAlert

                echo -e "\n\n A base de dados da Intranet Vindula está configurada.\n"
                sleep 3

            else

                if [[ -f /opt/intranet/app/intranet/vindula/bin/importdb.sh ]]; then

                    local mensaInfo=" *** ATENÇÃO *** "
                    local corInfo="41;"
                    mensaAlert

                    echo -e "\n\n A base de dados da Intranet Vindula ainda \e[1mNÃO\e[m está\
                    \n configurada corretamente."

                    cd /opt/intranet/app/intranet/vindula/bin/
                    ./importdb.sh

                else

                    local corInfo="42;"
                    local mensaInfo="  *** Intranet Vindula ***  "

                    mensaAlert

                    echo -e "\n\n A Intranet Vindula não está instalada. Utilize o comando \e[1msudo ./Vindula.sh\e[m\n"

                fi   
            fi

        else

            varMy=0
            checkDBpass=" "

            checkDB

        fi
    fi        

}

executorInstancia(){

if [[ -n $opcD ]] && [[ -z $varRecur ]]; then

        cd /

        echo "`$varInstancia ${vetStausInst[i]}`"

        sleep 3.5

        if [[ UbuntuServer -eq 1 ]]; then

            echo -e "\n  Dentro de instantes, o navegador\
            \n  será carregado com a \e[1mIntranet Vindula\e[m."

            x-www-browser localhost:8080/vindula/&

        else        

            verificadorINSTACIA
            verificaIP
        fi

else

    local corInfo="44;"
    local mensaInfo="       MODO FG       "
    mensaAlert

    varRecur=""
    executorInstancia

fi

}

verificadorProcessoPID(){

cd /

varInstancia='sudo -u vindula ./opt/intranet/app/intranet/vindula/bin/instance'

vetStausInst=(start status stop 'fg')

echo -e "`$varInstancia ${vetStausInst[i]}`"

recebeSaida=$_

validaRece=$(echo "$recebeSaida" | sed -r '/pid/!g' )

i=""

}

verificadorINSTACIA(){

local conexao=""
local tempoEspera="" 

while [[ $conexao -eq 1 ]] | [[ $tempoEspera -le 10 ]]; do

    nc -z localhost 8080

    conexao=$?

    if [[ -n $status ]] && [[ $conexao != 0 ]]; then 

        status=""
        menuPrincipal
        exit 0

    else    

        echo -ne " Aguarde a verificação ... [ $tempoEspera ] \r"
        sleep 0.45

        ((tempoEspera++))
    fi    

done

if [[ $conexao -eq 0 ]]; then

    local corInfo="42;"
    local mensaInfo="CONEXÃO ESTABELECIDA."

else

    local corInfo="41;"
    local mensaInfo="  CONEXÃO ENCERRADA  "
    
fi

 mensaAlert

 sleep 2
 echo -e "\n"

}

baseLayout(){

echo -e "\n  \e[40m                                    \e[m"
echo -e "  \e[40m \e[m\e[${coRa}m \e[m\e[40m \e[m\e[${coRaB}${txtSt}m \
${txtT} \e[m\e[40m \e[m\e[${coRaB}m  \e[m\e[40m \e[m\e[${coRaB}m \e[m\e[40m \
\e[m\e[${coRaB}m \e[m\e[40m \e[m" 
echo -e "  \e[40m \e[m\e[${coRa}m \e[m\e[${txtSd}m${txtLd} \e[m" 
echo -e "  \e[40m \e[m\e[${coRa}m \e[m\e[${txtSa}m${txtDi} \e[m"
echo -e "  \e[40m \e[m\e[${coRa}m \e[m\e[${txtSb}m${txtLa} \e[m"
echo -e "  \e[40m \e[m\e[${coRa}m \e[m\e[${txtSb}m${txtLb} \e[m"
echo -e "  \e[40m \e[m\e[${coRa}m \e[m\e[${txtSc}m${txtLc} \e[m"
echo -e "  \e[40m                                    \e[m \n"

}

opcInvalida(){

        clear

        txtLd="                                 "
        txtLa=" --------------------------------"
        txtT=" !!! OPÇÃO INVÁLIDA !!!"
        txtDi="      Essa opção não exite!      "
        txtLb=" Escolha uma das opções validas  "
        txtLc=" no menu principal.              "
       
            estiExep
            baseLayout  

        sleep 2;

        estiPrinci
        menuPrincipal
}

estiApro(){

    coRa=42
    coRaB=43
}

estiInst(){

    coRa=41
    coRaB=43
}

estiExep(){

    coRa=43
    coRaB=41
    txtSc="40;37;6"

}

estiSair(){

        clear

        txtT=" O Vindula agradece.  "
        txtLd="  Obrigado por utilizar o Vindula"
        txtDi=" Você gostaria de saber mais     "
        txtLa=" sobre nossos serviços?          "
        txtLb="                                 "
        txtLc="   http://www.vindula.com.br     "

        txtSd="40;37;1"
        txtSa="40;37;6"

            estiApro
            baseLayout 
            sleep 2

    if [[ $varVl -eq 200 ]] && [[ $opcI = [Ss] ]]; then

        local corInfo="42;"
        local mensaInfo="INSTALAÇÃO COMPLETA"

        mensaAlert

        echo -e "\n"

        cursorVI

    fi     

exit 0

}

estiPrinci(){

    clear

    txtSt=";37;1"

    txtSd="40;31;1"
    txtSa="40;33;1"
    txtSb="40;37;6"
    txtSc="40;37;6"

    txtLd="                                 "
    txtDi="  * Escolha uma opção no menu *  "
    txtLa=" --------------------------------"
    txtLc=" [0] - Sair                      "

}

confirmarInt(){
   
     clear

        txtT=" Confirmar Instalação !"
        txtLd="        -*- ATENÇÃO -*-          "
        txtDi="   Antes de instalar o Vindula.  "
        txtLa=" Para prosseguir com a instalação,"
        txtLb=" Deseja instalar as dependencias?"   
        txtLc=" [s]- Sim | [n]- Não | [0]- Sair "

            txtSc="40;37;1"
            estiInst
            baseLayout  

}

confirmarIntOPC(){

        cursorVI
        read opcI
        echo -e "\a"

    case "$opcI" in

        s | S )
            aguardIni
            estiSair
            ;;
        n | N )   
            estiPrinci     
            menuPrincipal
            ;;
        0)
            estiSair
            ;;
        *)
            opcInvalida
            confirmarIntOPC
            ;;
    esac

}

aguardIni(){

     clear
     estiApro
     txtDi="           * AGUARDE *           "
     txtLb="          será iniciada.         "
     txtSc="40;37;6"
     txtLc="                                 "

     if [[ $opcI != [Ss] ]]; then

        txtT="Inicializando o Vindula"
        txtLd="                                 "
        txtLa=" Dentro de instantes, a intranet "
     
      baseLayout
      sleep 2
      opcI=""
      executorInstancia

     else

        txtT="Instalando o Vindula..."
        txtLd="                                 "
        txtLa=" Dentro de instantes a instalação"

      baseLayout
      sleep 2
      instalarVindula 

     fi 
       
}

estiPrinci

i=1

MENSAGEM_USO="
Uso: $(basename "$0") ['OPCOES']

OPCOES:
\e[1m
  -a, --ajuda           - Mostra a ajuda
  -V, --versao          - Mostra a versão do programa e sai
  -I, --instalar        - Instalar a Intranet (Reset da Instalação)
      --statos          - Mostra o Statu da execução da intranet.
      --dados           - reinstação do bando de dados.
\e[m
"
        case "$1" in

           -a | --ajuda )

                clear
                echo -e " $MENSAGEM_USO"

                exit 0
                ;;

           -V | --versao )

                echo -e "\n `cat $(basename "$0")\
                | sed -r '/^# Vers/!g'\
                | sed '/^$/d' \
                | sed -n '/\#/{p;q;}'`\n"

                exit 0
                ;;

           -I | --instalar )
              
                confirmarInt
                confirmarIntOPC

                exit 0
                ;;

            --statos )
                
                status=" "       
                ;; 

            --dados)

                checkDB

                exit 0

                ;;   
            *)
                if test -n "$1"; then 
                    echo -e "\n A opção [ $1 ] é inválida. \n"
                    exit 0
                fi
                ;;
        esac

verificadorProcessoPID

menuPrincipal 