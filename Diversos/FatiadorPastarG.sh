#!/bin/bash

# O intuito desse ShellScript é para dividir uma pastar com muitíssimos aquivos em diversas pastas
# Os arquivos são da recuperação de arquivos, utilizando o FOREMOST, que tem o seguinte formato "112364.tipo_arquivo"

	# arquivo = SED http://thobias.org/doc/sosed.html
	# sed 's/^.*\///' arquivo -> sosed.html (Aqui tornar tudo que estiver para frente do caracter "selecionado")


path=$(pwd) 
	# Caminho absoluto da pasta com muitíssimos arquivos

pastaOrigin=$(echo $path | sed 's/^.*\///')
	# Apenas o nome da pasta

pastaDestinoBase=$(echo $path"_"Fatiado)
	# Diretório onde será criado subpastas e,  copiado os arquivos da pasta de original


if [[ ! -d "$pastaDestinoBase" ]]; then
	# Verifica se a subpasta não exite

	mkdir -pv $pastaDestinoBase # cria a subpasta com o caminho absoluto 
	echo -e "\n Diretório criado :\n $pastaDestinoBase"

else

	echo -e "\n Diretório Existente :\n"

fi




echo "-----------------"
echo $path
echo $pastaOrigin
echo $pastaDestinoBase
echo "-----------------"