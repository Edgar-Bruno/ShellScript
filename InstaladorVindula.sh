#!/bin/bash

cursorVI(){ sleep 0.25; echo -n "   -"; sleep 0.25; echo -n "> "; }

menuPrincipal(){

estiPrinci

 if [ -f /opt/vindula2.0/vindula/bin/instance ]; then
  
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

}

instalarVindula(){

clear;

apt-get -y install gcc g++ make build-essential libjpeg-dev libpng12-dev subversion mercurial zlib1g-dev
apt-get -y install libc6-dev python-setuptools python-virtualenv pkg-config libpcre3-dev libssl-dev
apt-get -y install python-openssl python-dev python-ldap  python-dev python-dateutil python-lxml libbz2-dev
apt-get -y install python-lxml libxml2 libxml2-dev libxslt-dev libncurses5 libncurses5-dev ruby rubygems
apt-get -y install mysql-server libmysqlclient-dev libmysqld-dev libsqlite3-dev libsasl2-dev git-core
apt-get -y install graphicsmagick ghostscript poppler-utils tesseract-ocr openoffice.org libldap2-dev
gem install docsplit

mkdir -v /opt/vindula2.0 /opt/python2.7

cursorVI

git clone https://github.com/vindula/buildout.python.git /opt/python2.7/buildout.python

cd /opt/python2.7/buildout.python/

python bootstrap.py

./bin/buildout -vN

/opt/python2.7/buildout.python/bin/virtualenv-2.7 --no-site-packages /opt/vindula2.0/

wget -c -P /opt/vindula2.0/ "http://downloads.sourceforge.net/project/vindula/2.0/Vindula-2.0LTS.tar.gz"

tar xvf /opt/vindula2.0/Vindula-2.0LTS.tar.gz -C /opt/vindula2.0/

cd /opt/vindula2.0/vindula/

../bin/easy_install -U distribute

../bin/easy_install -U setuptools

../bin/python bootstrap.py

./bin/buildout  -vN

menuPrincipal

}

executorInstancia(){

cd /
 ./opt/vindula2.0/vindula/bin/instance start
 sleep 5;
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

     if [ "$opcI" != s ]; then

        txtT="Inicializando o Vindula"
        txtLa=" Dentro de instantes o navegador "
        txtLb=" de internet será iniciado.      "

           executorInstancia 
     else

        txtT="Inicializando o Vindula"
        txtT="Instalação do Vindula  "
        txtLa=" Dentro de instantes a instalação"
        txtLb=" será iniciada.                  "
  
           instalarVindula         
     fi 
            txtLd="                                 "
            txtDi="   * Aguarde o carregamento *    " 
            txtLc="                                 "

      
       estiApro
       baseLayout
       sleep 2;
}

menuPrincipal    