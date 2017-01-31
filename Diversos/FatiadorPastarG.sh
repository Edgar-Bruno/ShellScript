#!/bin/bash

# O intuito desse ShellScript é para dividir uma pastar com muitíssimos aquivos em diversas pastas
# Os arquivos são da recuperação de arquivos, utilizando o FOREMOST, que tem o seguinte formato "112364.tipo_arquivo"
# arquivo = SED http://thobias.org/doc/sosed.html
# sed 's/^.*\///' arquivo -> sosed.html (Aqui tornar tudo que estiver para frente do caracter "selecionado")

path=$(pwd)

echo "-----------------"
echo $path
echo "-----------------"