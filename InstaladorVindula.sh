#!/bin/bash
#IntranetVindula
#
#
#Instala todos os requisitos necessários
#Executa a instancia da intranet.
# Versão 1.01 - 16/02/2014 Adicionado suporte comandos por linha de comango
# Versão 1.00 - 05/02/2014
#
#---------------------------------------------------------------------------

MENSAGEM_USO="
Uso: $0 [-h]

-a          Ajuda
-v          Mostra a versão do programa
"
if test "$1" = "-h"
    then
        echo "$MENSAGEM_USO"
        exit 0
fi        

cursorVI(){ sleep 0.25; echo -n "   -"; sleep 0.25; echo -n "> "; }

menuPrincipal(){

estiPrinci

 if [ -f /opt/intranet/app/intranet/vindula/bin/instance ]; then
  
    txtT="Vindula, a sua INTRANET"
    txtLb=" [1] - Iniciar a Intranet        "
    varVl=300

            estiApro
            baseLayout
 else

    txtT="Instalador o Vindula   "
    txtLb=" [1] - Instalar a Intranet       " 
    varVl=200
            estiInst
            baseLayout  
  fi

cursorVI
read opcD;
echo -e "\a"

        if [ "$opcD" == 0 ]; then
            opcE=100
        else
            opcE=$(($varVl-$opcD))
        fi  

case "$opcE" in

    199)
        confirmarInt
        ;;
    299)
        aguardIni
        ;;
    100)
        estiSair
        ;;
    *)
        opcInvalida
        menuPrincipal
        ;;
esac

opcE=-5

}

instalarVindula(){

add-apt-repository ppa:libreoffice/ppa 

apt-get update

apt-get -y install mysql-client mysql-server

apt-get -y install curl

apt-get update

vindulaD=`curl https://raw2.github.com/vindula/buildout.python/master/dependencias.txt`

for inst in $vindulaD; do echo "`apt-get -y install $inst`"; done 

gem install bundle 

gem install docsplit -v 0.6.4

mkdir -v /opt/core/ /opt/intranet/ /opt/intranet/app/ /opt/intranet/app/intranet/

git clone https://github.com/vindula/buildout.python.git /opt/core/python

cd /opt/core/python/

python bootstrap.py

easy_install - U distribute

./bin/buildout -vN

/opt/core/python/bin/virtualenv-2.7 --no-site-packages /opt/intranet/app/intranet/

wget -c -P /opt/intranet/app/intranet/ "http://mirror.vindula.com.br/Vindula-2.0.3LTS.tar.gz"


tar xvf /opt/intranet/app/intranet/Vindula-2.0.3LTS.tar.gz -C /opt/intranet/app/intranet/

cd /opt/intranet/app/intranet/vindula/

../bin/easy_install -U distribute

../bin/easy_install -U setuptools

../bin/python bootstrap.py

./bin/buildout -vN

sudo chown -R $USER:$USER /opt/intranet/

}

executorInstancia(){
cd /
 ./opt/intranet/app/intranet/vindula/bin/instance start
 sleep 10;
 x-www-browser localhost:8080/vindula/&
}

baseLayout(){

echo -e "\n  \e[40m                                    \e[m"
echo -e "  \e[40m \e[m\e[${coRa}m \e[m\e[40m \e[m\e[${coRaB}${txtSt}m ${txtT} \e[m\e[40m \e[m\e[${coRaB}m  \e[m\e[40m \e[m\e[${coRaB}m \e[m\e[40m \e[m\e[${coRaB}m \e[m\e[40m \e[m"    
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

        menuPrincipal
}

estiApro(){

    coRa=42
    coRaB=44
}

estiInst(){

    coRa=41
    coRaB=46
}

estiExep(){

    coRa=43
    coRaB=41
    txtSc="40;37;6"

}

estiSair(){

        clear

        txtT=" A Liberiun agradece.  "
        txtLd="  Obrigado por utilizar o Vindula"
        txtDi=" Você gostaria de saber mais     "
        txtLa=" sobre nossos serviços?          "
        txtLb="                                 "
        txtLc="   http://www.vindula.com.br     "

        txtSd="40;37;1"
        txtSa="40;37;6"

            estiApro
            baseLayout 
            sleep 2;
            exit;
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
        txtDi="   Antes de instalar o Vindula,  "
        txtLa=" deve-se instalar as dependêcnias"
        txtLb=" necessárias.                    "
        txtLc=" [s]- Sim | [n]- Não | [0]- Sair "

            txtSc="40;37;1"
            estiInst
            baseLayout  

        cursorVI
        read opcI
        echo -e "\a"

    case "$opcI" in

        s)
            aguardIni
            estiSair
            ;;
        n)        
            menuPrincipal
            ;;
        0)
            estiSair
            ;;
        *)
            opcInvalida
            ;;
    esac

}

aguardIni(){

     clear
     estiApro
     txtDi="           * AGUARDE *           "
     txtLb="          será iniciada.         "
     txtSc="40;37;6"

     if [ "$opcI" != s ]; then

        txtT="Inicializando o Vindula"
        txtLd="                                 "
        txtLa=" Dentro de instantes, a intranet "

        txtLc="                                 "
     
      baseLayout
      sleep 3;
      opcI=-5 
      executorInstancia

     else

        txtT="Instalando o Vindula..."
        txtLd="                                 "
        txtLa=" Dentro de instantes a instalação"
        txtLc="                                 "

      
      baseLayout
      sleep 3; 
      instalarVindula 

     fi 
       
}

menuPrincipal  
