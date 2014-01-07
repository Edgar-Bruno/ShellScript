#!/bin/bash

cursorVI(){ sleep 0.25; echo -n " -"; sleep 0.25; echo -n "> "; }

menuPrincipal(){
clear


echo "|===========================================|"
echo "|     INSTALADOR INTRANET VINDULA 2.0       |"
echo "|===========================================|"
echo "|          *  ESCOLHA UMA OPÇÃO  *          |"
echo "| [ 1 ]- Instalar a Intranet                |"
echo "| [ 2 ]- Executar a Intranet                |"
echo "| [ 0 ]- Sair                               |"
echo "|===========================================|"

cursorVI
read opcA;

case "$opcA" in
    1)
        cursorVI
        echo "-----------------------------------------------"
        cursorVI
        echo "[ 1 ]- Instalar a Intranet  "
        cursorVI
        instalarVindula
        ;;
    2)
        cursorVI
        echo "-----------------------------------------------"
        cursorVI
        echo "[ 2 ]- Executar a Intranet "
        cursorVI
        executorInstancia
        ;;
    0)
        clear
        cursorVI
        echo " Obrigado por utilizar o Vindula!"
        cursorVI
        echo "-----------------------------------------------"
        cursorVI
        clear
        ;;
    *)

        clear
        cursorVI
        echo "Digite uma opção válida."
        sleep 2;
        cursorVI
        echo "-----------------------------------------------"
        menuPrincipal
        ;;
esac

}



instalarVindula(){
	
cursorVI
clear;
cursorVI

echo "INSTALANDO DEPENDENCIAS"
sleep 2;

apt-get -y install gcc g++ make build-essential libjpeg-dev libpng12-dev subversion mercurial zlib1g-dev
apt-get -y install libc6-dev python-setuptools python-virtualenv pkg-config libpcre3-dev libssl-dev
apt-get -y install python-openssl python-dev python-ldap  python-dev python-dateutil python-lxml libbz2-dev
apt-get -y install python-lxml libxml2 libxml2-dev libxslt-dev libncurses5 libncurses5-dev ruby rubygems
apt-get -y install mysql-server libmysqlclient-dev libmysqld-dev libsqlite3-dev libsasl2-dev git-core
apt-get -y install graphicsmagick ghostscript poppler-utils tesseract-ocr openoffice.org libldap2-dev
gem install docsplit

clear;
cursorVI

echo "INSTALAÇÃO DAS DEPENDECIAS FINALIZADAS"

mkdir -v /opt/vindula2.0 /opt/python2.7

cursorVI

git clone https://github.com/vindula/buildout.python.git /opt/python2.7/buildout.python

cd /opt/python2.7/buildout.python/

python bootstrap.py

./bin/buildout -vN

/opt/python2.7/buildout.python/bin/virtualenv-2.7 --no-site-packages /opt/vindula2.0/

#wget -c -P /opt/vindula2.0/ "http://downloads.sourceforge.net/project/vindula/2.0.1/Vindula-2.0.1LTS.tar.gz"
wget -c -P /opt/vindula2.0/ "http://downloads.sourceforge.net/project/vindula/2.0/Vindula-2.0LTS.tar.gz"

tar xvf /opt/vindula2.0/Vindula-2.0LTS.tar.gz -C /opt/vindula2.0/

cd /opt/vindula2.0/vindula/

../bin/easy_install -U distribute

../bin/easy_install -U setuptools

../bin/python bootstrap.py

./bin/buildout  -vN

clear
sleep 2;
cursorVI
echo "A INSTALAÇÃO DA SUA INTRANET VINDULA FOI CONCLUÍDA COM SUCESSO!"
sleep 3;

menuPrincipal

}

executorInstancia(){
cd /	
 ./opt/vindula2.0/vindula/bin/instance fg
 menuPrincipal
}

menuPrincipal