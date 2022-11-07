// -------------------------------------
// Author: Tomás de Sousa Tunes Lopes
// Course: Operating Systems - Project 2
// -------------------------------------

#include "common.h"
#include <unistd.h>
#include <signal.h>
#include <stdlib.h>
#include <sys/wait.h>

// Variaveis Globais
Vaga vagas[NUM_VAGAS];
Enfermeiro *enfermeiros;
Cidadao novo;
Enfermeiro enf;

// Variaveis auxiliares
int nr_enfermeiros; //S2
int nr_vaga = 0;
int pid_filho;

void S1 () {
    FILE *servidorPid = fopen(FILE_PID_SERVIDOR, "w");
    if (fprintf(servidorPid, "%d", getpid())) {
        fclose(servidorPid);
        sucesso("S1) Escrevi no ficheiro FILE_PID_SERVIDOR o PID: %d", getpid());
    } else {
        erro("S1) Não consegui registar o servidor!");
        exit(1);
    }
}

void S2() {
    FILE *ficheiro = fopen(FILE_ENFERMEIROS, "r");
    if (ficheiro) {
        fseek(ficheiro, 0, SEEK_END);
        nr_enfermeiros = ftell(ficheiro) / (sizeof(Enfermeiro));
        sucesso("S2) Ficheiro FILE_ENFERMEIROS tem %d bytes, ou seja, %d enfermeiros", ftell(ficheiro), nr_enfermeiros);
        fseek(ficheiro, 0, SEEK_SET);
        enfermeiros = malloc(nr_enfermeiros * sizeof(Enfermeiro));
        fread(enfermeiros, sizeof(Enfermeiro) , nr_enfermeiros, ficheiro);
        fclose(ficheiro);
    } else {
        erro("S2) Não consegui ler o ficheiro FILE_ENFERMEIROS!\n");
        exit(1);
    }
}


void S3() {
    for (int i = 0; i < NUM_VAGAS; i++) {
        vagas[i].index_enfermeiro = -1;
    }
    sucesso("S3) Iniciei a lista de %d vagas", NUM_VAGAS);
}

void pid_Sig () {
    int pide_aux = wait(NULL);
    for (int i = 0; i < NUM_VAGAS; i++) {
        if (vagas[i].PID_filho == pide_aux) {
            int aux = vagas[i].index_enfermeiro;

            vagas[i].index_enfermeiro = -1;
            sucesso("S5.5.3.1) Vaga %d que era do servidor dedicado %d libertada", i, pid_filho);

            enfermeiros[aux].disponibilidade = 1;
            sucesso("S5.5.3.2) Enfermeiro %d atualizado para disponível", aux);

            enfermeiros[aux].num_vac_dadas++;
            sucesso("S5.5.3.3) Enfermeiro %d atualizado para %d vacinas dadas", aux, enfermeiros[aux].num_vac_dadas);

            FILE * file = fopen(FILE_ENFERMEIROS, "r+");
            if (file) {
                fseek(file, aux * sizeof(Enfermeiro), SEEK_SET);
                fread(&enf, sizeof(enf), 1, file);
                enf.num_vac_dadas++;
                fseek(file, sizeof(Enfermeiro) * -1, SEEK_CUR);
                fwrite(&enf, sizeof(Enfermeiro), 1, file);
                fclose(file);
                sucesso("S5.5.3.4) Ficheiro FILE_ENFERMEIROS %d atualizado para %d vacinas dadas", aux, enf.num_vac_dadas);
            } else {
                erro("Bonus: Não foi possivel abrir o ficheiro enfermeiros.txt para atualizar os dados");
            }
        }
    }
}

void terminar() {
    sucesso("S5.6.1) SIGTERM recebido, servidor dedicado termina Cidadão");
    kill(novo.PID_cidadao, SIGTERM);
    exit(0);
}

void S5 () {
    FILE *pedvacina = fopen(FILE_PEDIDO_VACINA, "r");
    if (pedvacina) {
        if (fscanf(pedvacina, "%d:%[^:]:%d:%[^:]:%[^:]:%d:%d", &novo.num_utente, novo.nome, &novo.idade, novo.localidade, novo.nr_telemovel, &novo.estado_vacinacao, &novo.PID_cidadao)) {
            printf("\nChegou o cidadão com o pedido nº %d, com nº utente %d, para ser vacinado no Centro de Saúde CS%s\n", novo.PID_cidadao, novo.num_utente, novo.localidade);
            sucesso("S5.1) Dados Cidadão: %d; %s; %d; %s; %s; %d", novo.num_utente, novo.nome, novo.idade, novo.localidade, novo.nr_telemovel, novo.estado_vacinacao);
        } else {
            erro("S5.1) Não foi possível ler o ficheiro FILE_PEDIDO_VACINA");
            return;
        }

    } else {
        erro("S5.1) Não foi possível abrir o ficheiro FILE_PEDIDO_VACINA");
        return;
    }
    fclose(pedvacina);

    char CSnovo[100];
    sprintf(CSnovo, "CS%s", novo.localidade);
    int alone = 0;
    for (int i = 0; i < nr_enfermeiros; i++) {
        if (strcmp(CSnovo, enfermeiros[i].CS_enfermeiro) == 0) {
            if (enfermeiros[i].disponibilidade == 1) {
                sucesso("S5.2.1) Enfermeiro %d disponível para o pedido %d", i, novo.PID_cidadao);
                for (nr_vaga; nr_vaga < NUM_VAGAS; nr_vaga++) {
                    alone = 1;
                    if (vagas[nr_vaga].index_enfermeiro == -1) {
                        sucesso("S5.2.2) Há vaga para vacinação para o pedido %d", novo.PID_cidadao);
                        vagas[nr_vaga].index_enfermeiro = i;
                        vagas[nr_vaga].cidadao = novo;
                        enfermeiros[i].disponibilidade = 0;
                        sucesso("S5.3) Vaga nº %d preenchida para o pedido %d", nr_vaga, novo.PID_cidadao);
                        break;
                    }
                }
                if (nr_vaga == NUM_VAGAS) {
                    erro("S5.2.2) Não há vaga para vacinação para o pedido %d", novo.PID_cidadao);
                    kill(novo.PID_cidadao, SIGTERM);
                    return;
                }
            } else {
                erro("S5.2.1) Enfermeiro %d indisponível para o pedido %d para o Centro de Saúde %s", i, novo.PID_cidadao, enfermeiros[i].CS_enfermeiro);
                kill(novo.PID_cidadao, SIGTERM);
                return;
            }
            break;
        }
    }

    if (alone == 0) {
        erro("Não existe nenhum enfermeiro registado no Centro de Saúde de %s", novo.localidade);
        kill(novo.PID_cidadao, SIGTERM);
        return;
    }

    pid_filho = fork();

    if (pid_filho == -1) {
        erro("S5.4) Não foi possível criar o servidor dedicado");
    }
    if (pid_filho == 0) {
        sucesso("S5.4) Servidor dedicado %d criado para o pedido %d", getpid(), novo.PID_cidadao);
        
        signal(SIGTERM, terminar);
        
        kill(novo.PID_cidadao, SIGUSR1);
        sucesso("S5.6.2) Servidor dedicado inicia consulta de vacinação");
        
        sleep(TEMPO_CONSULTA);
        sucesso("S5.6.3) Vacinação terminada para o cidadão com o pedido nº %d", novo.PID_cidadao);
        
        kill(novo.PID_cidadao, SIGUSR2);
        sucesso("S5.6.4) Servidor dedicado termina consulta de vacinação");
        exit(0);

    } else {
        vagas[nr_vaga].PID_filho = pid_filho;
        sucesso("S5.5.1) Servidor dedicado %d na vaga %d", pid_filho, nr_vaga);
        signal(SIGCHLD, pid_Sig);
        sucesso("S5.5.3.5) Retorna");
        return;
    }
}

void terminar_servidor() {
    for (int i = 0; i < NUM_VAGAS; i++) {
        if (vagas[i].PID_filho != 0)
            kill(pid_filho, SIGTERM);
    }
    remove(FILE_PID_SERVIDOR);
    sucesso("S6) Servidor terminado");
    exit(0);
}

int main () {
    S1();
    S2();
    S3();
    sucesso("S4) Servidor espera pedidos");
    signal(SIGUSR1, S5);
    signal(SIGINT, terminar_servidor);
    while (1) {
        pause();
    }
}
