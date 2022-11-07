// -------------------------------------
// Author: Tomás de Sousa Tunes Lopes
// Course: Operating Systems - Project 2
// -------------------------------------

#include "common.h"
#include <unistd.h>
#include <signal.h>
#include <stdlib.h>

Cidadao novo;

// C5 => Cancela o pedido e apaga o ficheiro
void C5 () {
    printf("\n");
    sucesso(" C5) O cidadão cancelou a vacinação, o pedido nº %d foi cancelado", getpid());
    remove(FILE_PEDIDO_VACINA); // Remove o ficheiro pedidovacina.txt
    exit(0);
}


// C1 => Pede ao cidadao os dados para fazer o registo
// C2 => Mostra o pid do cidadao
Cidadao novo_cidadao() {

    signal(SIGINT, C5); // Arma o sinal => C5

    printf("Bem-vindo ao registo \n");

    printf("\nIntroduza o seu numero de utente: ");
    scanf("%d", &novo.num_utente); // Guarda o numero de utente

    printf("Introduza o seu nome: ");
    my_fgets(novo.nome, 100, stdin); // Guarda o nome

    printf("Introduza a sua idade: ");
    scanf("%d", &novo.idade); //Guarda a idade

    printf("Introduza a sua localidade: ");
    my_fgets(novo.localidade, 100, stdin); // Guarda a localidade

    printf("Introduza o seu número de telemóvel: ");
    my_fgets(novo.nr_telemovel, 10, stdin); // Guarda o numero de telemovel

    novo.estado_vacinacao = 0; // Inicializa o estado de vacinacao como 0
    printf("\n");
    sucesso("C1) Dados Cidadão: %d; %s; %d; %s; %s; %d", novo.num_utente, novo.nome, novo.idade, novo.localidade, novo.nr_telemovel, novo.estado_vacinacao);
    sucesso("C2) PID Cidadão: %d", getpid());
}

void C3() {
    if (access(FILE_PEDIDO_VACINA, F_OK) == 0) {
        erro("C3) Não é possível iniciar o processo de vacinação neste momento");
    } else {
        sucesso("C3) Ficheiro FILE_PEDIDO_VACINA pode ser criado");
    }
}

void C4() {
    FILE *filec = fopen (FILE_PEDIDO_VACINA, "w");
    if (filec) {
        fprintf(filec, "%d:%s:%d:%s:%s:%d:%d", novo.num_utente, novo.nome, novo.idade, novo.localidade, novo.nr_telemovel, novo.estado_vacinacao, getpid());
        fclose(filec);
        sucesso("C4) Ficheiro FILE_PEDIDO_VACINA criado e preenchido");
    } else
        erro("C4) Não é possível criar o ficheiro FILE_PEDIDO_VACINA");
}

void C6 () {
    int pidServ;
    FILE *servidorPid = fopen(FILE_PID_SERVIDOR, "r");
    if (servidorPid == NULL) {
        erro("C6) Não existe ficheiro FILE_PID_SERVIDOR!");
        exit(1);
    }
    fscanf(servidorPid, "%d", &pidServ);
    kill(pidServ, SIGUSR1);
    sucesso("C6) Sinal enviado ao Servidor: %d", pidServ);
    fclose(servidorPid);
}

//C7
void C7() {
    sucesso("C7) Vacinação do cidadão com o pedido nº %d em curso", getpid());
    remove(FILE_PEDIDO_VACINA);
}

//C8
void C8() {
    sucesso("C8) Vacinação do cidadão com o pedido nº %d concluída", getpid());
    exit(0);
}

//C9
void C9() {
    sucesso("C9) Não é possível vacinar o cidadão no pedido nº %d", getpid());
    remove(FILE_PEDIDO_VACINA);
    exit(0);
}

int main() {
    Cidadao novo = novo_cidadao();

    // C3 e C4
    FILE *file = fopen(FILE_PEDIDO_VACINA, "r");
    if (file) { 
        erro("C3) Não é possível iniciar o processo de vacinação neste momento");
        signal(SIGALRM, C3); // C10
        while (access(FILE_PEDIDO_VACINA, F_OK) == 0) {
            alarm(5); //Espera cinco segundos e envia um sinal SIGALRM
            pause();
        }
        fclose(file);

    } else
        sucesso("C3) Ficheiro FILE_PEDIDO_VACINA pode ser criado");
    C4();
    C6();
    signal(SIGUSR1, C7); // Arma o sinal => C7
    signal(SIGUSR2, C8); // Arma o sinal => C8
    signal(SIGTERM, C9); // Arma o sinal => C9
    while (1) { // Fica em espera passiva
        pause();
    }
}
