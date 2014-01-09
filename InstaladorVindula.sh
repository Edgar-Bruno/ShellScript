#!/bin/bash
cursorVI(){ sleep 0.25; echo -n "   -"; sleep 0.25; echo -n "> "; }
menuPrincipal(){

estiPrinci

 if [ -f /opt/vindula2.0/vindula/bin/instance ]; then
   
    txtT=" Vindula, a sua INTRANET"
    txtLb=" [1] - Iniciar a Intranet"
    
            coRa=42
            coRaB=44
            baseLayout

 else

    txtT=" Instalador o Vindula  "
    txtLb=" [1] - Instalar a Intranet" 
         
            coRa=41
            coRaB=44
            baseLayout  
 fi

cursorVI
read opcE;
echo -e "\a"

case "$opcE" in
    1)
       confirmarInt
        ;;
    2)
        cursorVI
        echo "-----------------------------------------------"
        cursorVI
        echo "[ 2 ]- Executar a Intranet "
        cursorVI

        varz=$(whoami)
        echo "edgar bruno" > eeee;
        echo "$varz"
        executorInstancia

      # chown "$varz":"$varz" luli
        ;;
    0)
        estiSair
        ;;
    *)
        opcInvalida
        ;;
esac

}

instalarVindula(){

clear;

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
 ./opt/vindula2.0/vindula/bin/instance start
 #x-www-browser localhost:8080

 menuPrincipal
}

baseLayout(){

echo -e " \n \e[${coRa}m \e[m \e[${coRaB}${txtSt}m ${txtT} \e[m \e[${coRaB}m  \e[m \e[${coRaB}m \e[m \e[${coRaB}m \e[m"    
echo -e " \e[${coRa}m \e[m \e[${txtSb}m ${txtLd} \e[m" 
echo -e " \e[${coRa}m \e[m \e[${txtSa}m ${txtDi} \e[m"
echo -e " \e[${coRa}m \e[m \e[${txtSb}m ${txtLa} \e[m"
echo -e " \e[${coRa}m \e[m \e[${txtSb}m ${txtLb} \e[m"
echo -e " \e[${coRa}m \e[m \e[${txtSb}m ${txtLc} \e[m \n"

}

opcInvalida(){

        clear
        txtT=" !!! OPÇÃO INVÁLIDA !!!"
        txtDi="    Essa opção não exite!      "
        txtLb="Escolha uma das opções validas "
        txtLc="no menu principal."
        txtLa=""
        txtLd=""

            estiAlerta
            baseLayout  

        sleep 2;

        menuPrincipal
}

estiAlerta(){

    coRa=41
    coRaB=41
    txtSa="40;33;1"
}

estiSair(){

        clear
        txtT=" A Liberiun agradece.  "
        txtDi="    Essa opção não exite!      "
        txtLd="Escolha uma das opções validas "
        txtLa="Escolha uma das opções validas "
        txtLb="no menu principal."
        txtLc=""

            coRa=42
            coRaB=41
            baseLayout 

        sleep 2;
}
estiPrinci(){

    clear
    txtSa="40;37;1"
    txtSt=";37;1"
    txtSb=";0"

    txtLd=""
    txtDi=""
    txtLa="-------------------------------"
    txtLc=" [0] - Sair"
    txtDi=" * Escolha uma opção no menu * "
    
}

confirmarInt(){
   
     clear
        txtT=" Confirmar Instalação !"
        txtLd="     -*- ATENÇÃO -*-           "
        txtDi="Antes de instalar o Vindula,   "
        txtLa="deve-se instalar as dependêcnias"
        txtLb="necessárias"
        txtLc=" [s] - Sim  [n] - Não"

 
            coRa=41
            coRaB=42
            txtSa="40;33;1"
            txtSb="1"
            baseLayout  

        sleep 2;

        cursorVI
        read opcI

        case "$opcI" in
    s)
       #instalarVindula
       echo "Install"
       sleep 2;
       menuPrincipal
        ;;
    n)  
        echo "Cancel"
        sleep 2;
        menuPrincipal
        ;;
    0)
        
        ;;
    *)
        opcInvalida
        ;;
esac

}

menuPrincipal    
