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

if ! [ $# -eq 0 ]; then
    echo -e "\n${vermelho}Erro de Sintaxe:${sc} $0\n"

elif [ ! -f listagem.txt ]; then
    echo -e "\n${vermelho}Erro${sc}: Ficheiro 'listagem.txt' não existe\n"
else
    awk -v year="$(date +%Y)" 'BEGIN{FS="(:|-| \\|)";OFS=":"} {print (NR)+10000,$2,(year-$6),$8,$10,"0"}' listagem.txt > cidadaos.txt
    echo -e "\n${azul}Cidadãos registados na plataforma:${sc}\n\n${verde}N° de Utente   Nome                   Idade   Localidade         Nº Telemóvel   Estado de Vacinação${sc}"
    echo -e "$(awk -F ':' '{printf "%-14s %-22s %-7s %-18s %-32s %-2s\n",$1,$2,$3,$4,$5,$6}' cidadaos.txt)\n"
fi