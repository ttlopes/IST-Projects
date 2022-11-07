#!/bin/bash

# -------------------------------------
# Author: Tomás de Sousa Tunes Lopes
# Course: Operating Systems - Project 1
# -------------------------------------

# Constantes das cores
vermelho='\033[1;31m' # Vermelho
azul='\033[1;34m' #Azul
verde='\033[1;32m' #Verde
sc='\033[0m' # Sem cor

if ! [ $# -eq 0 ]; then
    echo -e "\n${vermelho}Erro de Sintaxe:${sc} $0\n"

elif [ ! -f enfermeiros.txt ]; then
    echo -e "\n${vermelho}Erro:${sc} O ficheiro enfermeiros.txt não existe, invoque o script adiciona_enfermeiros.sh para criar o ficheiro e adicionar enfermeiros\n"

elif [ ! -f cidadaos.txt ]; then
    echo -e "\n${vermelho}Erro:${sc} O ficheiro cidadaos.txt não existe, invoque o script lista_cidadaos.sh para criar o ficheiro\n"

elif [ $(awk -F ':' '{if($5==1)print $5}' enfermeiros.txt | wc -l) -eq 0 ]; then
    echo -e "\n${vermelho}Erro:${sc} Não existem enfermeiros disponíveis\n"

elif [ $(cat cidadaos.txt | wc -l) -eq 0 ]; then
    echo -e "\n${vermelho}Erro:${sc} Não existem cidadãos registados\n"
else
    agenda = $(awk -v date="$(date +"%Y-%m-%d")" 'BEGIN{FS=OFS=":"} FNR==NR {if($5==1) {sub(/^CS/,"",$3); array[$3]=$0; next}} $4 in array {split(array[$4],enf); if($6<2) print enf[2],enf[1],$2,$1,"CS"$4,date}' enfermeiros.txt cidadaos.txt | sort) # > agenda.txt
    if [ ! -z "$agenda" ];then
        echo "$agenda" > agenda.txt
        echo -e "\nAgendamento criado com sucesso!\n\n${azul}Agendamento da vacinação:${sc}\n\n${verde}Centro de Saúde      Enfermeiro/a              N° da Cédula Profissional      Cidadão                   N° de Utente         Data da Vacinação${sc}"
        echo -e "$(awk -F ':' '{printf "%-20s %-25s %-30s %-25s %-20s %-20s\n",$5,$1,$2,$3,$4,$6}' agenda.txt | sort)\n"
    else
        echo -e "\n${vermelho}Erro:${sc} Não foi possível criar o agendamento devido a não haver enfermeiros e cidadãos compatíveis\n"
    fi
fi