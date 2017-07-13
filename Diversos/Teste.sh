#!/bin/bash


#/home/edgarbruno/Downloads/backup - Rafa/Data Recovery 2017-01-27 at 07.19.25

Edgar="X-Wing"
Vivi="MArmortasSauro"
PedRO="Doidinho"


var="Edgar Vivi PedRO" 

for i in $var; do
	echo ${!i}
	eval "$i=\"XXXxx\""
	echo "-----"
	echo ${!i}
	echo "----->>>>>"
done

local y=""
local x=""

while [[ y -lt 6 ]]; do

    if [[ x -gt 1 ]]; then
        x=0
        coAle="40;"
    else
        coAle="$corInfo"
    fi
    
    echo -ne "  EDGAR"

    sleep 0.25

    ((x++))

    ((y++))

done
#Used bash shell to support for loop syntax used below
 
#The no of times you want to iterate
#count=3
 
#add any no of variables you wish to print in loop
#DIR1=/home/a
#UN1=Harsh1
#Time1=10
 
#DIR2=/home/b
#UN2=Harsh2
#Time2=20
 
#DIR3=/home/c
#UN3=Harsh3
#Time3=30
 
#echo
#for loop to run based on count variable
#for (( i=1; i<=$count; i++ ))
#do
#  echo $(eval echo '$'$(eval echo DIR$i))
#  echo $(eval echo '$'$(eval echo UN$i))
#  echo $(eval echo '$'$(eval echo Time$i))
#  echo
#done