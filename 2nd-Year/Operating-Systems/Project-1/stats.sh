#!/bin/bash

# -------------------------------------
# Author: Tomás de Sousa Tunes Lopes
# Course: Operating Systems - Project 1
# -------------------------------------

# Constantes das cores
vermelho='\033[1;31m' # Vermelho
azul='\033[1;34m' # Azul
verde='\033[1;32m' # Verde
laranja='\033[1;33m' # Laranja
sc='\033[0m' # Sem cor

if [[ $# -eq 0 || $# -gt 2 || $# -eq 2 && $1 != cidadaos || $# -eq 1 && $1 != registados && $1 != enfermeiros ]]; then
    echo -e "\n${vermelho}Erro de Sintaxe:${sc} As opções disponíveis são:\n$0 cidadaos “<localidade>”\n$0 registados\n$0 enfermeiros\n"

elif [[ ! -f cidadaos.txt && $1 != enfermeiros ]]; then
    echo -e "\n${vermelho}Erro:${sc} O ficheiro cidadaos.txt não existe, invoque o script lista_cidadaos.sh para criar o ficheiro\n"

elif [[ ! -f enfermeiros.txt && $1 = enfermeiros ]]; then
    echo -e "\n${vermelho}Erro:${sc} O ficheiro $1.txt não existe, invoque o script adiciona_$1.sh para criar o ficheiro e adicionar enfermeiros\n"

elif [[ -z "$2" && $1 = cidadaos ]];then
    echo -e "\n${vermelho}Erro:${sc} Não introduziu nenhuma \e[4mlocalidade\e[0m\n"

else
    # Opção para os cidadãos
    if [[ $1 = cidadaos ]];then
        var=$(awk -F ':' '{print $4}' cidadaos.txt | grep "$2" | wc -l)
        if [ $var -gt 0  ];then
            echo -e "\nO número de cidadãos registados em \e[4m$2\e[0m é $var\n"
        else
            echo -e "\nNão existem cidadãos registos em \e[4m$2\e[0m!\n"
        fi

    # Opção para os registados
    elif [[ $1 = registados ]];then
        lista=$(sort -r -t ':' -k3 cidadaos.txt | awk -F ':' '{if($3>60)printf "%-25s %-15s\n",$2,$1}')
        if [ ! -z "$lista" ];then
            echo -e "\nOs cidadãos com mais de \e[4m60 anos\e[0m são: \n\n${laranja}Nome                      N° de Utente${sc}\n$lista\n"
        else
            echo -e "\nNão existem cidadãos com mais de \e[4m60 anos\e[0m\n"
        fi

    # Opção para os enfermeiros
    elif [[ $1 = enfermeiros ]];then
        enfermeiros=$(awk -F ':' '{if($5==1)printf "%-25s %-15s\n",$2,$3}' enfermeiros.txt | sort)
        if [ ! -z "$enfermeiros" ];then
            echo -e "\n${azul}Enfermeiros disponíveis:${sc}\n\n${verde}Nome                      Centro de Saúde${sc}\n$enfermeiros\n"
        else
            echo -e "\nNão existem enfermeiros disponíveis\n"
        fi
    fi
fi