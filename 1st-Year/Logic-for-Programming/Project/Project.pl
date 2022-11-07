% ----------------------------------
% Author: Tomás de Sousa Tunes Lopes
% Course: Logic for Programming
% ----------------------------------

% ------------------------------------------------------------------------------
% extrai_ilhas_linha(N_L, Linha, Ilhas)
% Retira o numero de pontes e qual a sua posicao na lista
% Devolve uma ilha(P, (X, Y)); o X e a Linha
% ------------------------------------------------------------------------------

extrai_ilhas_linha(N_L, Linha, Ilhas) :- 
    extrai_ilhas_linha(N_L, Linha, 0, [], Ilhas).

% Base de recursao
extrai_ilhas_linha(_, [], _, Ilhas, Ilhas) :- !.

% Caso tenha uma ponte
extrai_ilhas_linha(N_L, [ Cabeca | Resto ], Counter, Aux, Ilhas) :-
    Cabeca > 0, !,
    NovoCounter is Counter + 1,
    append(Aux, [ilha(Cabeca, (N_L, NovoCounter))], NovoAux),
    extrai_ilhas_linha(N_L, Resto, NovoCounter, NovoAux, Ilhas).

% Caso seja 0
extrai_ilhas_linha(N_L, [ _ | Resto ], Counter, Aux, Ilhas) :-
    NovoCounter is Counter + 1,
    extrai_ilhas_linha(N_L, Resto, NovoCounter, Aux, Ilhas).

% ------------------------------------------------------------------------------
% ilhas(Puz, Ilhas)
% Recebe uma lista de listas e aplica a funcao extrai_ilhas_linha, o X vai ser a
% a posicao da lista na lista
% ------------------------------------------------------------------------------

ilhas(Puz, Ilhas) :- ilhas(Puz, 0, [], Ilhas).

% Base de recursao
ilhas([], _, Ilhas, Ilhas) :- !.

% Caso essa linha tenha alguma ilha
ilhas([ Cabeca | Resto ], Counter, Aux, Ilhas) :-
    \+ sum_list( Cabeca, 0),
    NovoCounter is Counter + 1,
    extrai_ilhas_linha(NovoCounter, Cabeca, Ilha),
    append(Aux, Ilha, NovoAux),
    ilhas(Resto, NovoCounter, NovoAux, Ilhas).

% Else
ilhas([ _ | Resto ], Counter, Aux, Ilhas) :-
    NovoCounter is Counter + 1,
    ilhas(Resto, NovoCounter, Aux, Ilhas).

% ------------------------------------------------------------------------------
% vizinhas(Ilhas, Ilha, Vizinhas)
% Recebendo uma lista de Ilhas, vai retirar as que sao vizinhas da lista.
% Ou seja vai retirar as ilhas mais perto em cima, na esquerda, na direita e em
% baixo
%
% Na minha funcao ele vai buscar as ultimas ilhas que fizerem parte do eixo
% superior e da esquedas e vai buscar as primeiras ilhas do eixo da direita e
% inferior
% ------------------------------------------------------------------------------

% C -> Cima, E-> Esquerda, D -> Direita, B -> Baixo

vizinhas(Ilhas, Ilha, Vizinhas) :- 
    append(Ilhas, [ilha(0, (0, 0))], NovasIlhas),
    vizinhas(NovasIlhas, Ilha, [], [], [], [], [], Vizinhas).

% Base de recursao
vizinhas([], _, _, _, _, _, Vizinhas, Vizinhas) :- !.

% Cima
vizinhas([ ilha(P1, (X1, Y1)) | Resto ], ilha(P2, (X2, Y2)), _, E, D, B, Aux, Vizinhas) :-
	Y1 == Y2,
    X1 \== X2,
    X1 < X2, !,
    vizinhas(Resto, ilha(P2, (X2, Y2)), ilha(P1, (X1, Y1)), E, D, B, Aux, Vizinhas).

% Esquerda
vizinhas([ ilha(P1, (X1, Y1)) | Resto ], ilha(P2, (X2, Y2)), C, _, D, B, Aux, Vizinhas) :-
	X1 == X2,
    Y1 \== Y2,
    Y1 < Y2, !,
    vizinhas(Resto, ilha(P2, (X2, Y2)), C, ilha(P1, (X1, Y1)), D, B, Aux, Vizinhas).

% Direita
vizinhas([ ilha(P1, (X1, Y1)) | Resto ], ilha(P2, (X2, Y2)), C, E, D, B, Aux, Vizinhas) :-
	X1 == X2,
    Y1 \== Y2,
    Y1 > Y2, 
    is_list(D), ! ,
    vizinhas(Resto, ilha(P2, (X2, Y2)), C, E, ilha(P1, (X1 , Y1)), B, Aux, Vizinhas).

% Baixo
vizinhas([ ilha(P1, (X1, Y1)) | Resto ], ilha(P2, (X2, Y2)), C, E, D, B, Aux, Vizinhas) :-
	Y1 == Y2,
    X1 \== X2,
    X1 > X2, 
    is_list(B), !,
    vizinhas(Resto, ilha(P2, (X2, Y2)), C, E, D, ilha(P1, (X1, Y1)), Aux, Vizinhas).

% Junta todos e retira os conjuntos vazios
vizinhas([ _ | Resto ], Ilha, C, E, D, B, _, Vizinhas) :-
    delete([C, E, D, B], [], Final),
    vizinhas(Resto, Ilha, C, E, D, B, Final, Vizinhas).


% ------------------------------------------------------------------------------
% estado(Ilhas, Estado)
% Recebe uma lista de Ilhas e cria uma entrada para cada uma das ilhas da lista
% Uma entrada consiste em 3 elementos, o primeiro eh a ilha, o segundo eh as ilhas
% vizinhas dessa ilha e o ultimo vai ser a lista de pontes da ilhas que por agora
% vai ficar vazia -> []
% ------------------------------------------------------------------------------

estado(Ilhas, Estado) :- estado(Ilhas, Ilhas, [], [],Estado).

% Base de recursao
estado(_, [], _, Estado, Estado) :- !.

estado(Ilhas, [ Cabeca | Resto ], _, Aux, Estado) :-
    vizinhas(Ilhas, Cabeca, IlhasAux),
    append(_, [Cabeca], Aux3),
    append(Aux3, [IlhasAux], Aux4),
    append(Aux4, [[]], Aux5),
    append(Aux, [Aux5], NovoAux), !,
    estado(Ilhas, Resto, IlhasAux, NovoAux, Estado).


% ------------------------------------------------------------------------------
% posicoes_entre(Pos1, Pos2, Posicoes)
% Recebe duas posicoes e devolve as posicoes entre elas, se nao pertecerem a
% mesma coluna ou linha retorna false
% ------------------------------------------------------------------------------


posicoes_entre(Pos1, Pos2, Posicoes) :- 
    posicoes_entre(Pos1, Pos2, 0, [] , Posicoes).

% Base de recursao
posicoes_entre(Pos, Pos, _, Posicoes, Posicoes) :- !.

posicoes_entre((X, Y1), (X, Y2), _, Aux, Posicoes) :-
    Y1 < Y2, !,
    Y1Aux is Y1 + 1,
    (Y1Aux == Y2 -> posicoes_entre((X, Y1Aux), (X, Y2), Y2, Aux, Posicoes);
    append(Aux, [(X, Y1Aux)], NovoAux),
    posicoes_entre((X, Y1Aux), (X, Y2), Y2, NovoAux, Posicoes)).
    
posicoes_entre((X, Y1), (X, Y2), _, Aux, Posicoes) :-
    Y1 > Y2, !,
    Y2Aux is Y2 + 1,
    (Y2Aux == Y1 -> posicoes_entre((X, Y1), (X, Y2Aux), Y1, Aux, Posicoes);
    append(Aux, [(X, Y2Aux)], NovoAux),
    posicoes_entre((X, Y1), (X, Y2Aux), Y1, NovoAux, Posicoes)).
    
posicoes_entre((X1, Y), (X2, Y), _, Aux, Posicoes) :-
    X1 < X2, !,
    X1Aux is X1 + 1,
    (X1Aux == X2 -> posicoes_entre((X1Aux, Y), (X2, Y), X2, Aux, Posicoes);
    append(Aux, [(X1Aux, Y)], NovoAux),
    posicoes_entre((X1Aux, Y), (X2, Y), X2, NovoAux, Posicoes)).
    
posicoes_entre((X1, Y), (X2, Y), _, Aux, Posicoes) :-
    X1 > X2, !,
    X2Aux is X2 + 1,
    (X2Aux == X1 -> posicoes_entre((X1, Y), (X2Aux, Y), X1, Aux, Posicoes);
    append(Aux, [(X2Aux, Y)], NovoAux),
    posicoes_entre((X1, Y), (X2Aux, Y), X1, NovoAux, Posicoes)).

% ------------------------------------------------------------------------------
% cria_ponte(Pos1, Pos2, Ponte)
% Recebe duas posicoes e devolve a ponte. A ponte tem este formato -> ponte(Pos1, Pos2)
% e eh ordenada
% ------------------------------------------------------------------------------


cria_ponte(Pos1, Pos2, Ponte) :- 
    cria_ponte(Pos1, Pos2, ponte(Pos1, Pos2), Ponte).

% Base de recursao
cria_ponte(Pos, Pos, Ponte, Ponte) :- !.

% Pos1 < Pos2
cria_ponte((X1, Y1), (X2, Y2), Ponte, Ponte) :- 
    (X1 + Y1) < (X2 + Y2), !,
    cria_ponte(0, 0, Ponte, Ponte).

% Pos2 < Pos1
cria_ponte((X1, Y1), (X2, Y2), _, Ponte) :- 
    (X1 + Y1) > (X2 + Y2), !,
    cria_ponte(0, 0, ponte((X2, Y2), (X1, Y1)), Ponte).

% ------------------------------------------------------------------------------
% caminho_livre(Pos1, Pos2, Posicoes, I, Vz)
% Verifica se existe um caminho livre entre duas ilhas quando adicionada uma
% nova ponte
% ------------------------------------------------------------------------------

caminho_livre((X3, Y3), (X4, Y4), _, ilha(_, (X1, Y1)), ilha(_, (X2, Y2))) :-
    X3 == X1,
    X4 == X2,
    Y3 == Y1,
    Y4 == Y2 , !.

caminho_livre((X3, Y3), (X4, Y4), _, ilha(_, (X1, Y1)), ilha(_, (X2, Y2))) :-
    X3 == X2,
    X4 == X1,
    Y3 == Y2,
    Y4 == Y1 , !.

caminho_livre(_, _, Posicoes, ilha(_, (X1, Y1)), ilha(_, (X2, Y2))) :-
    posicoes_entre((X1, Y1), (X2, Y2), Vizinhas),
    \+ contem(Vizinhas, Posicoes).

contem(Vizinhas, [ Cabeca | _ ]) :-
    member(Cabeca, Vizinhas), !.

contem(Vizinhas, [ _ | Resto ]) :-
    contem(Vizinhas, Resto).

% ------------------------------------------------------------------------------
% actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, Entrada)
% Atualiza as ilhas vizinhas da entrada quando e adicionada uma ponte
% ------------------------------------------------------------------------------

actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, [Ilha1, Vizinhas, Pontes], Nova_Entrada) :- 
    actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, [Ilha1, Vizinhas, Pontes], [Ilha1, [], Pontes], Nova_Entrada).

% Base de recursao
actualiza_vizinhas_entrada(_, _, _, [ _, [], _], Nova_Entrada, Nova_Entrada) :- !.

actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, [Ilha, [ Cabeca | Resto ], Ponte], [Ilha, Aux, Ponte], Nova_Entrada) :-
    caminho_livre(Pos1, Pos2, Posicoes, Ilha, Cabeca), 
    append(Aux, [ Cabeca], NovoAux), !,
    actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, [Ilha, Resto, Ponte], [Ilha, NovoAux, Ponte], Nova_Entrada).

actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, [Ilha, [ _ | Resto ], Ponte], Aux, Nova_Entrada) :-
    actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, [Ilha, Resto, Ponte], Aux, Nova_Entrada).

% ------------------------------------------------------------------------------
% actualiza_vizinhas_apos_pontes(Estado, Pos1, pos2, Novo_estado)
% Actualiza o estado de multiplas entradas quando e adicionada uma ponte
% ------------------------------------------------------------------------------

actualiza_vizinhas_apos_pontes(Estado, Pos1, Pos2, Novo_estado) :- 
    actualiza_vizinhas_apos_pontes(Estado, Pos1, Pos2, [], Novo_estado), !.

% Base de recursao
actualiza_vizinhas_apos_pontes([], _, _, Novo_estado, Novo_estado) :- !.

actualiza_vizinhas_apos_pontes([ Cabeca | Resto ], Pos1, Pos2, Aux, Novo_estado) :-
    posicoes_entre(Pos1, Pos2, Posicoes),
    actualiza_vizinhas_entrada(Pos1, Pos2, Posicoes, Cabeca, Entrada),
    append(Aux, [Entrada], NovoAux),
    actualiza_vizinhas_apos_pontes(Resto, Pos1, Pos2, NovoAux, Novo_estado).
    
% ------------------------------------------------------------------------------
% ilhas_terminadas(Estado, Ilhas_term)
% Retira as ilhas terminadas, ou seja, as que tiverem um numero de pontes igual
% ao tamanho da lista das pontes. As que tem 'X' nao estao terminadas
% ------------------------------------------------------------------------------

ilhas_terminadas(Estado, Ilhas_term) :- ilhas_terminadas(Estado, [], Ilhas_term).

% Base de recursao
ilhas_terminadas([], Ilhas_term, Ilhas_term):-!.

ilhas_terminadas([ [ilha(P, C), _, List] | Resto ], Aux, Ilhas_term) :-
    P \== 'X',
    length(List, P), !,
    append(Aux, [ilha(P, C)], NovoAux),    
    ilhas_terminadas(Resto, NovoAux, Ilhas_term).

ilhas_terminadas([ _ | Resto ], Aux, Ilhas_term) :-
    ilhas_terminadas(Resto, Aux, Ilhas_term).

% ------------------------------------------------------------------------------
% tira_ilhas_terminadas_entrada(Ilhas_term, Entrada, Nova_entrada)
% Tira as ilhas terminadas da lista de vizinhas da entrada
% ------------------------------------------------------------------------------

tira_ilhas_terminadas_entrada(Ilhas_term, [Ilha, Vizinhas, Pontes], Nova_entrada) :- 
    tira_ilhas_terminadas_entrada(Ilhas_term, [Ilha, Vizinhas, Pontes], [Ilha, [], Pontes], Nova_entrada).

% Base de recursao
tira_ilhas_terminadas_entrada(_, [ _, [], _], Nova_entrada, Nova_entrada) :- !.

tira_ilhas_terminadas_entrada(Ilhas_term, [Ilha, [ Cabeca | Resto ], Pontes], [Ilha, Aux, Pontes], Nova_entrada) :-
    \+ member(Cabeca, Ilhas_term), !,
    append(Aux, [Cabeca], NovoAux),
    tira_ilhas_terminadas_entrada(Ilhas_term, [Ilha, Resto, Pontes], [Ilha, NovoAux, Pontes], Nova_entrada).

tira_ilhas_terminadas_entrada(Ilhas_term, [Ilha, [ _ | Resto ], Pontes], Aux, Nova_entrada) :-
    tira_ilhas_terminadas_entrada(Ilhas_term, [Ilha, Resto, Pontes], Aux, Nova_entrada).

% ------------------------------------------------------------------------------
% tira_ilhas_terminadas(Estado, Ilhas-term, Novo_estado)
% Tira as ilhas terminadas da lista de vizinhas de cada uma das entradas
% ------------------------------------------------------------------------------

tira_ilhas_terminadas(Estado, Ilhas_term, Novo_estado) :- tira_ilhas_terminadas(Estado, Ilhas_term, [], Novo_estado).

% Base de recursao
tira_ilhas_terminadas([], _, Novo_estado, Novo_estado) :- !.

tira_ilhas_terminadas([ Cabeca | Resto ], Ilhas_term, Aux, Novo_estado) :-
    tira_ilhas_terminadas_entrada(Ilhas_term, Cabeca, Aux2),
    \+ length(Aux2, 0), !,
    append(Aux, [Aux2], NovoAux),
    tira_ilhas_terminadas(Resto, Ilhas_term, NovoAux, Novo_estado).

tira_ilhas_terminadas([ _ | Resto ], Ilhas_term, Aux, Novo_estado) :-
    tira_ilhas_terminadas(Resto, Ilhas_term, Aux, Novo_estado).

% ------------------------------------------------------------------------------
% marca_ilhas_terminadas_entrada(Ilhas_term, Entrada, Nova_entrada)
% Se pertencer as ilhas terminadas substitui o numero de pontes por 'X'
% ------------------------------------------------------------------------------

marca_ilhas_terminadas_entrada(Ilhas_term, [ilha(P, Cor), V, Pontes], Nova_entrada) :-
    member(ilha(P, Cor), Ilhas_term), !,
    Nova_entrada = [ilha('X', Cor), V, Pontes].

marca_ilhas_terminadas_entrada(_, Entrada, Nova_entrada) :-
    Nova_entrada = Entrada.

% ------------------------------------------------------------------------------
% marca_ilhas_terminadas(Estado, Ilhas_term, Novo_estado)
% Se pertencer as ilhas terminadas substitui o numero de pontes por 'X' em cada
% uma das entradas
% ------------------------------------------------------------------------------

marca_ilhas_terminadas(Estado, Ilhas_term, Novo_estado) :- marca_ilhas_terminadas(Estado, Ilhas_term, [], Novo_estado).

% Base de recursao
marca_ilhas_terminadas([], _, Novo_estado, Novo_estado) :- !.

marca_ilhas_terminadas([ Cabeca | Resto ], Ilhas_term, Aux, Novo_estado) :-
    marca_ilhas_terminadas_entrada(Ilhas_term, Cabeca, Aux2),
    append(Aux, [Aux2], NovoAux),
    marca_ilhas_terminadas(Resto, Ilhas_term, NovoAux, Novo_estado).

% ------------------------------------------------------------------------------
% trata_ilhas_terminadas(Estado, Novo_estado)
% Aplica as funcoes ilhas_terminadas, tira_ilhas_terminadase e marca_ilhas_terminadas
% ao Estado
% ------------------------------------------------------------------------------

trata_ilhas_terminadas(Estado, Novo_estado) :-
    ilhas_terminadas(Estado, Ilhas_term),
    tira_ilhas_terminadas(Estado, Ilhas_term, Novo_estado_Aux),
    marca_ilhas_terminadas(Novo_estado_Aux, Ilhas_term, Novo_estado).

% ------------------------------------------------------------------------------
% junta_pontes(Estado, Num_pontes, Ilha1, Ilha2, Novo_estado)
% Cria as pontes entre Ilhas1 e Ilha2, adiciona as pontes criadas as entradas de 
% Estado que correspondem as ilhas e depois no final aplica as funcoes 
% actualiza_vizinhas_apos_pontes e trata_ilhas_terminadas
% ------------------------------------------------------------------------------

junta_pontes(Estado, Num_pontes, ilha(P1, Cor1), ilha(P2, Cor2), Novo_estado) :- 
    length(ListaPontes, Num_pontes),
    cria_ponte(Cor1, Cor2, Ponte),
    maplist(=(Ponte), ListaPontes),
    junta_pontes(Estado, ilha(P1, Cor1), ilha(P2, Cor2), ListaPontes, [], Novo_estado).

% Base de recursao
junta_pontes([], ilha(_, Cor1), ilha(_, Cor2), _, Aux, Novo_estado) :- 
    actualiza_vizinhas_apos_pontes(Aux, Cor1, Cor2, Novo_estado2),
    trata_ilhas_terminadas(Novo_estado2, Novo_estado).

junta_pontes([ [Ilha1, V, _] | Resto ], Ilha1, Ilha2, ListaPontes, Aux, Novo_estado) :- 
    member(Ilha2, V), !,
    append(Aux, [ [Ilha1, V, ListaPontes]], NovoAux),
    junta_pontes(Resto, Ilha1, Ilha2, ListaPontes, NovoAux, Novo_estado).

junta_pontes([ [Ilha2, V, _] | Resto ], Ilha1, Ilha2, ListaPontes, Aux, Novo_estado) :- 
    member(Ilha1, V), !,
    append(Aux, [[Ilha2, V, ListaPontes]], NovoAux),
    junta_pontes(Resto, Ilha1, Ilha2, ListaPontes, NovoAux, Novo_estado).

junta_pontes([Cabeca| Resto ], Ilha1, Ilha2, ListaPontes, Aux, Novo_estado) :- 
    append(Aux, [Cabeca], NovoAux),
    junta_pontes(Resto, Ilha1, Ilha2, ListaPontes, NovoAux, Novo_estado).