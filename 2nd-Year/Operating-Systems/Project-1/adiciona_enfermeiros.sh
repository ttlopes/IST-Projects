#!/bin/bash

# -------------------------------------
# Author: Tomás de Sousa Tunes Lopes
# Course: Operating Systems - Project 1
# -------------------------------------

# Constantes das cores
vermelho='\033[1;31m' # Vermelho
azul='\033[1;34m' # Azul
verde='\033[1;32m' # Verde
sc='\033[0m' # Sem cor

if [ $# -ne 4 ]; then
    echo -e "\n${vermelho}Erro de Sintaxe:${sc} $0 “<nome>” <número da cédula profissional> “<CSLocalidade>” <disponibilidade(0-indisponível / 1-disponível)>\n"

elif [ -z "$1" ];then
    echo -e "\n${vermelho}Erro:${sc} Não introduziu nenhum nome\n"

elif [[ $3 != CS* ]]; then
    echo -e "\n${vermelho}Erro:${sc} O nome do centro de saúde tem de começar por “CS”\n"

elif ! [[ "$2" =~ ^[0-9]+$ ]]; then
    echo -e "\n${vermelho}Erro:${sc} O número da cédula profissional tem de ser um número\n"

elif ! [[ $4 = 1 || $4 = 0 ]]; then
    echo -e "\n${vermelho}Erro:${sc} A disponibilidade varia entre 0-indisponível e 1-disponível\n"

elif [ -f enfermeiros.txt ]; then
    if [ ! -z "$(awk -v CSI="$3" -F ':' '$3 == CSI {print $3}' enfermeiros.txt)" ]; then
        echo -e "\n${vermelho}Erro:${sc} O Centro de Saúde introduzido já tem um enfermeiro registado\n"

    elif [ ! -z "$(awk -v CSI="$2" -F ':' '$1 == CSI {print $1}' enfermeiros.txt)" ]; then
        echo -e "\n${vermelho}Erro:${sc} O enfermeiro ${azul}$1${sc} já se encontra registado no centro de saúde de ${azul}$(awk -v id=$2 -F ':' '{sub(/^CS/,"",$3);if($1==id)print $3}' enfermeiros.txt)${sc}\n"

    else
        echo "$2:$1:$3:0:$4" >> enfermeiros.txt
        echo -e "\nO/A enfermeiro/a ${azul}$1${sc} foi adicionado com sucesso!\n"
        echo -e "${azul}Enfermeiros registados na plataforma:${sc}\n\n${verde}Centro de Saúde           Nome                      N° da Cédula Profissional   N° de Vacinações Efetuadas   Disponibilidade${sc}"
        echo -e "$(sort -t ':' -k3 enfermeiros.txt | awk -F ':' '{if($5==1)printf "%-25s %-25s %-27s %-28s %-2s\n",$3,$2,$1,$4,"Disponível"}{if($5==0)printf "%-25s %-25s %-27s %-28s %-2s\n",$3,$2,$1,$4,"Indisponível"}')\n"
    fi
else
    echo "$2:$1:$3:0:$4" > enfermeiros.txt
    echo -e "\nFicheiro criado com sucesso!\n\nO/A enfermeiro/a ${azul}$1${sc} foi adicionado com sucesso!\n"
    echo -e "${azul}Enfermeiros registados na plataforma:${sc}\n\n${verde}Centro de Saúde           Nome                      N° da Cédula Profissional   N° de Vacinações Efetuadas   Disponibilidade${sc}"
    echo -e "$(sort -t ':' -k3 enfermeiros.txt | awk -F ':' '{if($5==1)printf "%-25s %-25s %-27s %-28s %-2s\n",$3,$2,$1,$4,"Disponível"}{if($5==0)printf "%-25s %-25s %-27s %-28s %-2s\n",$3,$2,$1,$4,"Indisponível"}')\n"
fi