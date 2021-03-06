#!/bin/bash

#/Downloads/backup - Rafa/Data Recovery 2017-01-27 at 07.19.25

#Edgar="X-Wing"
#Vivi="MArmortasSauro"
#PedRO="Doidinho"

var="Edgar Vivi PedRO" 
# Variavel dinamica(Criar e Inserir valores) - EVAL
for i in $var; do
    echo $i
	echo ${!i}
	eval "$i=SANJIRO"
	echo "-----"
	echo ${!i}
	echo "----->>>>>"
done

local y=""
local x=""

while [[ y -lt 1 ]]; do

    if [[ x -gt 1 ]]; then
        x=0
        coAle="40;"
    else
        coAle="$corInfo"
    fi
    
    echo -ne "  EDGAR"

    sleep 0.15

    ((x++))

    ((y++))

done

x=0
for i in {0..1}; do
    
    if [[ x -le 24 ]]; then
        echo "******* $i"
    elif [[ x -ge 25 ]] && [[ x -le 45 ]]; then
        varx="Edgar Bruno \r \n $x\r"
        echo -en "$varx"
        # echo -en "------ $i \n"
        # echo -en "Edgar $x \r"
        #sleep 1

        #statements
    else
        x=0
    fi

    ((x++))
done



# path="/home/edgarbruno/.local/share/Trash/files/backup - Rafa/Data Recovery 2017-01-27 at 07.19.25/Gráfico/jpg"
# pastaDestinoBase="/media/edgarbruno/F141-93F4/Gráfico/J2"


leituraEscrita=0
# leituraEscrita=0 Verificação padrão dos marcadores de Backups de endereços. O padrão é, marcadores VAZIOS
# leituraEscrita=1 Verificação dos marcadores de Backups de endereços a fim de

pathBasename=$(readlink -f ${BASH_SOURCE[0]})
# pathBasename=$(find ~/ -name $(basename "$0"))
# Pega o endereço de onde o Shellscript está.
# echo "----- $pathBasename"

function verificadorBOeD()
{

    # ARRAY
    listOD=(Borigem Bdestin)
    # Marcadores dos backups dos endereços de Origem e Destino

    listVar=(OrigT DestT)
    # Variaveis que recebem os endereços de Origem e Destino

    listPaths=(path pastaDestinoBase)
    # Lista das variável principais.

    x=0
    varR=2

    echo "----"
    for i in ${listOD[@]};do
        
        eval "${listVar[x]}=\"$(sed -n '/'$i'/h;${x;p;}; ' "$pathBasename" | sed 's/'$i'//;s/^ //;s/ *$//')\"" 

        if [[ $leituraEscrita -eq 0 ]]; then
            # Verifica se os endereços de backups de Origem e Destino estão preencidos no marcadores
            
            if [[ ! -z ${!listVar[x]} ]]; then
                # Execuçao do script terminada inesperadamente e deve ser verificado
                # echo "NOT NULL  ------> [${!listVar[x]}]"
                
                if [[ -d "${!listVar[x]}" ]]; then
                    # Verifica se o caminho encontrado existe - SIM
                    eval "${listPaths[x]}='${!listVar[x]}'"
                    # Atribui o valor encontrado no Marcado nas variável principais.
                    # echo "Pasta existe"
                    ((opc++))
                    ((varR--))
                else
                    # Verifica se o caminho encontrado existe - NÂO
                    echo -e "Pasta NÃO ENCONTRADA\
                            \n \e[1m ${!listVar[x]} \e[m"
                    ((varR++))
                fi
                 # Regra para a opção correta
                if [[ $opc -eq 21 ]]; then
                    paran="Not Null"
                    cancelVAR="Not Null"
                fi

            else
                # Marcador vazio = Padrão satisfeito
                ((varR--))
                # echo "IS NULL ------> [${listVar[x]}]"
            fi

        else
            varR=0
            # Apaga ou escreve nos marcadores dos endereços de backups de Origem e Destino

            if [[ -z ${!listVar[x]} ]]; then
                # Escreve os marcadores de backups de Origem e Destino
                # ESCREVE

                echo "WRITE ... "
                echo "IS NULL  ------> [${!listVar[x]}]"
                echo "$(sed ':a;$!{N;ba;};s|\(.*\)'$i'|\1'$i' '"${!listPaths[x]}"'|' < "$pathBasename")" > "$pathBasename" #----> Escrever OK
                # Substituir a última ocorrência de uma string por outra 

            else

                # Paga os marcadores de backups de Origem e Destino
                # APAGA

                echo "ERASE ... $i"
                echo "NOT NULL ------> [${!listVar[x]}]"
                # echo "$(sed ':a;$!{N;ba;};s|\(.*\)'$i' '"${!listVar[x]}"'|\1'$i'|' < "$pathBasename")" > "$pathBasename" #----> Pagar OK
                echo "$(sed 's/^'$i'.*/'$i'/' < "$pathBasename")" > "$pathBasename"
                # *** *** *** *** *** *** ***
                # Deve-se apagar TUDO que estiver após o marcador não, o endereço já existente

            fi
            
        fi
        ((x++))
        # Enumeração forçada
    done

    # !!! CASO OCORRA UMA FALHA ONDE APENAS UM DOS MARCADORES ESTÁ PREENCHIDO, AMBOS SERÃO APAGADOS
    # CRIAR CONDIÇÃO AQUI
    if [[ $varR -ne 0 ]]; then
        echo " UMA das pasta não existe"
        leituraEscrita=1
        verificadorBOeD  
    fi
}

# verificadorBOeD
pastaDestinoBase="/media/edgarbruno/F141-93F4/Gráfico/J2Bori"
path="/home/edgarbruno/.local/share/Trash/files/backup"
    
#pastaDestinoBase=
#path=

# ARRAY
listOD=(Borigem Bdestin)
# Marcadores dos backups dos endereços de Origem e Destino mais os seus respectivos valores

listPaths=(path pastaDestinoBase)
# Lista das variável do diretórios principais.

leituraEscrita=0

function verificadorBOeDNEW()
{
# Refatoração do metodo verificadorBOeD

    if [ $leituraEscrita -eq 0 ]; then
    # Aqui é definido quando os marcadores serão escritos ou apagados
    # = 0 -> Leitura dos Marcadores encontrados

        local leiORI="$(sed -n '/'${listOD[0]}'/h;${x;p;}' "$pathBasename")"
        # Imprimir a última ocorrência da linha com determinada string
        # Recebe os marcadores de backups e seus valores

        eval "${listOD[0]}='$(sed 's/'${listOD[1]}'.*$//;s/'${listOD[0]}'//;s/^ //;s/ *$//' <<< "$leiORI")'"
        # Pega o caminho absoluto da origem dos dados
        
        eval "${listOD[1]}='$(sed 's/^.*'${listOD[1]}' //' <<< "$leiORI")'"
        # Pega o caminho absoluto do destino dos dados
        
        if [[ -d ${!listOD[0]} ]] && [[ -d ${!listOD[1]} ]]; then
        # Verifica se os caminhos exitem
        # Mandem os marcadores existente para continuar o processamento

            echo "EXISTEM"
            eval "${listPaths[0]}='${!listOD[0]}'"
            eval "${listPaths[1]}='${!listOD[1]}'"
       
        else
        # !!! CASO OCORRA UMA FALHA ONDE APENAS UM DOS MARCADORES ESTÁ PREENCHIDO, AMBOS SERÃO APAGADOS
        
            echo "NÂO"
            eval "${listOD[0]}="
            eval "${listOD[1]}="
            leituraEscrita=1
            verificadorBOeDNEW
        fi

    else 
    # != 0 -> Escreve ou apaga os marcadores
    
        echo "Escreve/Apaga"    
        # String a ser gravado nos marcadores
        local varW="${listOD[0]} ${!listPaths[0]} ${listOD[1]} ${!listPaths[1]}"

        sed -i ':a;$!{N;ba;};s|\(.*\)'${listOD[0]}'.*|\1'"$varW"'|' "$pathBasename" # Escrita/Apaga OK
        # Substirui a última ocorrencia de string por outra apagando todo o conteúdo da linha

    fi
}


# eval $(echo "rsync -avhr --progress $(echo -e "\"$path/$arquivoCP\"") $(echo -e "\"$pastaDestinoBase/Fragmentado_$dNumero/$arquivoCP\"")")
verificadorBOeDNEW
#sed -i ':a;$!{N;ba;};s/\(.*\)Borigem/\1Borigem EDgar BRUNO SANJIRO/' "$pathBasename"
# Substituir a última ocorrência de uma string por outra




# Print lines between PAT1 and PAT2

# PAT1
# 3    - first block
# 4
# PAT2
# 5
# sed -n '/PAT1/,/PAT2/{//!p}'

# sed 's/dia.*$//'

# varX=$(sed -n '/Borigem/h;${x;p;}' "$pathBasename" | sed 's/Borigem //g')
# Pega o backup do endereço completo de origem
# sed -n '/Borigem/h;${x;p;}' - > Imprimir a última ocorrência da linha com determinada string
# sed -n '/Borigem .*home/p   - > Imprime '
# echo $varX

# varX=$(echo $varX | sed 's/Borigem /media/edgarbruno/F141-93F4/Gráfico/J2 /media/edgarbruno/F141-93F4/Gráfico/J2//g')


# echo $(sed -n '/i /' $pathBasename)

# echo "$(sed 's/dgar/'$varX'/'  < "$pathBasename")" > $pathBasename
# sed -e 's/ORI/SUB/g' - Substituição
# sed -e 's/ORI/'$variable'/g - Substituição com Variavel
# sed -e "s|ORI|$PWD|" ' - Substituição com Variavel contem /

#echo "$(sed -e "s|$varX| $pathBasename|" < $"$pathBasename")" > $pathBasename

# echo "EDGAR BRUNO " >> $pathBasename
#-----------------------------------------------------------------------------
#echo "$(sed -e "s|$varX||" < $"$pathBasename")" > "$pathBasename"
# Escreve no proprio arquivo, o backup do endereço de destino dos dados
#-----------------------------------------------------------------------------





    # echo "$(sed ":a;$!{N;ba;};s|\(.*\)$i|\1i$ $Dest|" < "$pathBasename")" > "$pathBasename"
    # echo "$(sed ":a;$!{N;ba;};s|\(.*\)'$i'|\1'$i' '${!listVar[x]}'|" < "$pathBasename")" > "$pathBasename"
    #echo "$(sed ":a;$!{N;ba;};s|\(.*\)Borigem|\1EDGAR_BRUNO|" < "$pathBasename")" > "$pathBasename"



# echo "$(sed ':a;$!{N;ba;};s/\(.*\)eval/\1Noite/' "$pathBasename")" ---> Em todo texto
# echo "$(sed 's|\(.*\)'$x'|\1XXX|' < xxx)"                          ---> Em cada linha do texto
# Substituir a última ocorrência de uma string por outra


exit 0

# sed -i "s/>>> ${arquivoCP}/\[ OK \] ${arquivoCP}/"
# echo "$(sed ''$linhaVersoa's/.*/'$versConfC'/' < $(basename "$0"))" > $(basename "$0")
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
#  echo $(eval echo '$'$(eval echo Time$i $Dest $Dest Noite Noite Noite Noite Noite Noite))
#  echo
#done

# Backup dos diretórios, caso, a leitura do diretório pesquisa tenha sido interrompida antes de concluír o arquivo de controle.
# Chamado com paramento especifico

Borigem /home/edgarbruno/.local/share/Trash/files/backup Bdestin /media/edgarbruno/F141-93F4/Gráfico/J2Bori