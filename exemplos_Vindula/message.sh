#!/bin/bash
c=1
lock="/tmp/.mlock"
while [ $c -le 50 ]
do
	ETH=$(ifconfig | grep eth | awk '{print $1}')
	IP=$(ifconfig $ETH | grep "inet end" | awk '{print $3}')
	ipvalido=$(echo $IP | egrep '^(([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.){3}([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])$')
 
	if [ "$ipvalido" == "127.0.0.1" ];then
		if  [ ! -f "$lock" ];then
			touch $lock
			zenity --info --height=50 --text="Aguarde um instante, enquanto o Vindula esta sendo carregado. Uma janela do browser sera aberta automaticamente." 
		fi
	else
		if [ "$ipvalido" != "" ] && [ -f "$lock" ];then
			zenity --info --height=50 --text="Para acessar sua Intranet de outro computador em sua rede local, acesse: http://$IP."
			c=50
		else
			zenity --info --height=50 --text="Aguarde um instante, enquanto o Vindula esta sendo carregado. Uma janela do browser sera aberta automaticamente. 
			\n\nPara acessar sua Intranet de outro computador em sua rede local, acesse: http://$IP."
			c=50
		fi
	fi

	(( c++ ))
	sleep 20
done
