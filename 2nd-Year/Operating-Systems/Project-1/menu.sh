#!/bin/bash

# -------------------------------------
# Author: Tomás de Sousa Tunes Lopes
# Course: Operating Systems - Project 1
# -------------------------------------

# Constantes das cores
vermelho='\033[1;31m' # Vermelho
azul='\033[1;34m' # Azul
amarelo='\033[1;33m' # Amarelo
sc='\033[0m' # Sem cor

if ! [ $# -eq 0 ]; then
    echo -e "\n${vermelho}Erro de Sintaxe:${sc} $0\n"
    exit 1
fi

while [[ $opcao != sair ]];do
    clear
    echo -e "${azul}"
    figlet -f smslant "Covid - IUL"
    echo -e "${sc}"
    echo -e "${azul}1.${sc} Listar cidadãos\n${azul}2.${sc} Adicionar enfermeiro\n${azul}3.${sc} Stats\n${azul}4.${sc} Agendar vacinação\n${azul}0.${sc} Sair"
    read -n 1 -p $'\x0aEscolha uma opção: ' opcao

    case $opcao in
        1)  # Listar cidadãos
            clear
            echo -e "$(./lista_cidadaos.sh)\n"
            read -n 1 -s -r -p "Prima qualquer tecla para continuar"
            ;;
        2)  # Adicionar enfermeiro
            clear
            echo -e "\nPrima ${azul}ENTER${sc} sem nada escrito para sair\n"
            read -p 'Nome do enfermeiro: ' nome
            if [ ! -z "$nome" ]; then
                read -p "Número da cédula profissional: " id
                if [ ! -z "$id" ]; then
                    read -p "Localidade do Centro de Saúde: " cs
                    if [ ! -z "$cs" ]; then
                        read -p "Disponibilidade: " disp
                        if [ ! -z "$disp" ]; then
                            clear
                            if [[ $cs == CS* ]]; then
                                echo -e "$(./adiciona_enfermeiros.sh "$nome" $id "$cs" $disp)\n"
                            else
                                echo -e "$(./adiciona_enfermeiros.sh "$nome" $id "CS$cs" $disp)\n"
                            fi
                            read -n 1 -s -r -p "Prima qualquer tecla para continuar"
                        fi
                    fi
                fi
            fi
            ;;
        3)  # Stats
            clear
            echo -e "${azul}"
            figlet -f smslant "Stats"
            echo -e "${sc}"
            echo -e "${azul}1.${sc} Cidadãos\n${azul}2.${sc} Registados\n${azul}3.${sc} Enfermeiros\n\n${azul}Prima qualquer tecla para voltar ao menu anterior${sc}"
            read -n 1 -p $'\x0aEscolha uma opção: ' stats
            clear
            case $stats in
                1)  # Cidadãos
                    echo -e "\nPrima ${azul}ENTER${sc} sem nada escrito para sair\n"
                    read -p "Escolha a cidade: " cidade
                    if [ ! -z "$cidade" ]; then
                        clear
                        echo -e "$(./stats.sh cidadaos "$cidade")\n"
                        read -n 1 -s -r -p "Prima qualquer tecla para continuar"
                    fi
                    ;;
                2)  # Registados
                    echo -e "$(./stats.sh registados)\n"
                    read -n 1 -s -r -p "Prima qualquer tecla para continuar"
                    ;;
                3)  # Enfermeiros
                    echo -e "$(./stats.sh enfermeiros)\n"
                    read -n 1 -s -r -p "Prima qualquer tecla para continuar"
                    ;;
            esac
            ;;
        4)  # Agendar vacinação
            clear
            echo -e "$(./agendamento.sh)\n"
            read -n 1 -s -r -p "Prima qualquer tecla para continuar"
            ;;
        0)  # Sair
            opcao=sair
            clear
            echo -e "${amarelo}"
            cowsay -f tux "Até à próxima!"
            echo -e "${sc}"
            ;;
    esac
done