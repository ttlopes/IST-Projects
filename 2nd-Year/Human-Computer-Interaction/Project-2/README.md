# Projeto 2 - Seleção de Alvos Fora de Alcance

## 1. Desafio

O objetivo do segundo bake-off é diminuir o tempo de seleção de alvos fora do alcance do utilizador numa interface abstrata. É disponibilizado um código-fonte em p5.js que:

Mostra uma grelha de 6x3 alvos aos vossos utilizadores (Figura 1);

Indica qual o alvo a selecionar e a área de input do utilizador;

Quantifica o desempenho do utilizador com base na taxa de sucesso (accuracy, 0-100%), tempo total da tarefa (segundos), tempo médio por alvo (segundos), e tempo médio por alvo com penalização se a taxa de sucesso do vosso utilizador foi inferior a 95% (segundos) -- Figura 2;

Guarda estas métricas de desempenho na plataforma Firebase;

Reconhece input do utilizador numa área restrita do ecrã, e gera um cursor virtual em resposta a este input.

Para vencerem este bake-off têm de alterar o código-fonte fornecido de maneira a que os vossos utilizadores selecionem os alvos o mais rapidamente possível (atenção à penalização por taxas de sucesso abaixo dos 95%).

Têm também de calcular e imprimir uma métrica adicional: o Fitts Index of Performance (índice de dificuldade, ID). Devem usar a fórmula proposta por Mackenzie: log2 (distância-ao-alvo desde a última seleção / largura-do-alvo + 1) -- ver aula teórica em "Fatores Humanos" e o capítulo 2.1.4 ("O movimento"). Devem guardar cada ID na Firebase e opcionalmente imprimi-los no final da tarefa (Figura 2). O cálculo do ID é feito usando o cursor virtual e não o cursor real do utilizador.

## 2. Funcionamento

O bake-off é um desafio de design em aberto. É crucial que iniciem um processo iterativo de geração e teste de ideias desde o primeiro dia. A vossa solução tem de obedecer às seguintes regras:

Podem aceder à lista de alvos a selecionar. No entanto, a dado momento só podem aceder ao alvo atual (i), o próximo alvo (i+1), e o alvo anterior (i-1)

Não podem existir alvos invisíveis ou impossíveis de selecionar. Garantam que os alvos são visíveis comparando a cor de preenchimento (fill) e a cor de fundo da vossa aplicação. Este delta deve ser no mínimo 50: http://colormine.org/delta-e-calculator

Não podem alterar o tamanho visual ou da hitbox dos alvos (1.5cm), o distanciamento entre eles, nem o seu posicionamento.

Não podem fazer alterações ao comportamento do cursor que sejam dependentes do alvo a selecionar; isto é, alterações ao comportamento do cursor terão de ser uniformes para todos os alvos. Não podem também alterar a área de seleção do cursor; esta tem que ser apenas uma coordenada/pixel

Não podem usar hardware adicional para além de um rato convencional

Não podem modificar o código-fonte que calcula as métricas de desempenho descritas em C., nem o código referente à Firebase em D

Não podem processar qualquer tipo de input do utilizador fora da zona pré definida no canto inferior direito do ecrã (nem alterar a posição e o tamanho da mesma). Podem alterar a representação desta zona

## 3. Recomendações

Confirmem com o docente do laboratório ou através do Discord se não tiverem a certeza se uma das vossas decisões de desenho quebra alguma das regras descritas acima.

Lembrem-se, o vosso objetivo de desenho é minimizar o tempo de seleção. Vejam com atenção ambas as aulas sobre Fatores Humanos, e ambos os capítulos 2 ("Nós, os Humanos") e 9.3 ("Avaliação preditiva")

Figura 2. Exemplo do ecrã de resultados com o Index of Performance (ID) para cada alvo.

Para evitarmos problemas de acesso e hosting recomendamos o seguinte editor web: https://editor.p5js.org/. Dito isto, podem optar por fazer host da vossa aplicação em qualquer domínio (desde que seja acessível aos vossos participantes no dia do bake-off).

Learn: https://p5js.org/learn/

Referência da linguagem: https://p5js.org/reference/

Exemplos: https://p5js.org/examples/

Bibliotecas: https://p5js.org/libraries/

## 4. Competição

O bake-off termina com uma competição que será realizada na aula de laboratório da semana de 18 de Abril. Cada aluno irá testar todos os projetos do seu turno com a exceção do seu próprio projeto. Estes testes serão realizados na aula e terão que terminar dentro do período de aula.

É da responsabilidade de cada grupo preparar a solução e o link de acesso à aplicação p5.js. A ordem de execução dos projetos por cada aluno será aleatória e da responsabilidade do docente do laboratório. Aos alunos pede-se que não interajam com os autores dos projetos durante o bake-off, que concluam as tarefas sem distrações e com máximo de concentração possível, e que usem um computador com rato por uma questão de consistência e justiça dos resultados.

Comportamentos desonestos (menos éticos) resultam na desqualificação da competição (cotação de 0.0v). Tempos médios de seleção dois desvios padrões acima ou abaixo da média serão descartados. Alunos com 3 ou mais avaliações descartadas serão penalizados com 0.5v. A mesma penalização será aplicada a alunos que não completem todas as avaliações dentro do tempo de aula.

Reportem algum projeto que quebre as regras definidas "2. Funcionamento" ao docente do laboratório.

## 5. Submissão

A submissão tem de ser feita até dia 22 de Abril às 23h59 via Fenix. Apenas um membro do grupo terá que realizar esta entrega; um documento com o seguinte formato IPM2011132646L04_Grupo42.txt e contendo apenas dois links:

Link para a aplicação p5.js (File > Share > Edit)

Link para vídeo YouTube (Unlisted) com a descrição do processo de desenho e solução final (com captions ou voice-over). A captação de vídeo com o telemóvel é suficiente já que a avaliação não contempla a qualidade de gravação ou edição. Por outro lado, o vídeo deve conter:

Ideias iniciais: quais foram? Um descrição rápida ou demonstração de esboços/protótipos é suficiente;

Duas iterações sobre a aplicação. Cada iteração deve descrever:

As novas ideias e o porquê destas (com base nos resultados da iteração anterior)

O número e descrição dos participantes (pelo menos cinco por iteração)

Os tempo médios com penalização

Solução final: demonstrem a solução final e expliquem as vossas opções de desenho finais;

O vídeo não deve ultrapassar os 3 minutos.

## 6. Avaliação

10.0v, Processo de Desenho: demonstrado através da submissão vídeo;

10.0v, Tempo médio de seleção de alvos (com penalização). Esta componente será calculada através dos resultados dos testes com utilizadores durante o bake-off. A métrica é calculada automaticamente pelo código-fonte fornecido e submetida para uma base de dados (Firebase). O tempo médio de seleção (com penalização) será associado à seguinte nota:

0.0: >= 0.835s

2.0v: ]0.767s ; 0.835s[

4.0v: ]0.699s ; 0.767s]

6.0v: ]0.631s ; 0.699s]

8.0v: ]0.563s ; 0.631s]

10.0v: <= 0.563s

1.0v, Utilizador mais rápido (bónus). O utilizador mais rápido de cada turno de laboratório receberá uma bonificação de 1.0v na nota final do bake-off (tempo médio de seleção com penalização).

-2.0v, Fitts Performance Index. Grupos que não calculem o Fitts Performance Index ou não os enviem para a nossa base de dados terão uma penalização de 2.0v. Erro neste cálculo acarreta uma penalização de 0.5v.

Caso não seja submetido o vídeo terão 0.0v nas primeiras duas componentes descritas acima (1. e 2.). Caso não submetam o projeto p5.js serão apenas avaliados na componente 1. (máximo 10.0v).

Grupos ou elementos que não compareçam na sessão de bake-off terão cotação de 0.0v na componente 2., com exceção de casos com falta justificada (por ex. declaração médica).

Finalmente, grupos que quebram as regras definidas acima em "2. Funcionamento" terão cotação de 0.0v na componente 2. (alterarem o tamanho dos alvos etc).
