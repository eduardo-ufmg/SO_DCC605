**Universidade Federal de Minas Gerais**

**Disciplina: DCC065 - Sistemas Operacionais**

**Professor: Flavio Vinicius Diniz de Figueiredo**

# Lista de Exercícios

## Conceitos Básicos

1. [Silberschatz 2.1] Qual a finalidade das chamadas de sistema? <br>
Chamadas de sistema permitem que aplicações, programas nos domínios de proteção mais externos, usem o hardware sem o acessar. Evitar o acesso ao hardware por aplicativos reduz o risco de que estes prejudiquem um ao outro ao falharem. Para isso, somente o kernel acessa hardware diretamente. Tal acesso é feito sob demanda, conforme as chamadas de sistema enfileiradas para atendimento.

2. [Silberschatz 2.6] Que chamadas de sistema têm de ser executadas por um interpretador de comandos (`shell`) para iniciar um novo processo? Em outras palavras, descreva as chamadas de sistema que são chamadas ao executar um processo como ```$ echo oi``` <br>
fork: o processo pai (P), cria um processo filho (F) <br>
&nbsp;&nbsp;&nbsp;&nbsp;F é uma nova execução do shell (?) <br>
&nbsp;&nbsp;&nbsp;&nbsp;para P, o valor retornado pela fork é o pid de F <br>
&nbsp;&nbsp;&nbsp;&nbsp;para F, o valor retornado pela fork é 0 <br>
exec: o processo filho solicita ao SO que o substitua pelo processo iniciado pelo comando passado como argumento <br>
wait: opcionalmente, P pode aguardar a conclusãode F para seguir seu fluxo

1. [Silberschatz 2.8 - Alterada] Considerando uma arquitetura em camadas. Qual a finalidade da mesma? Quais são as vantagens? E as desvantagens? <br>
uma arquitetura em camadas busca proteger partes críticas do sistema contra acesso por aplicativos de terceiros. <br>
esta proporciona maior segurança e organização ao sistema. <br>
nesta, todo acesso ao hardware é atrasado e recursos extras são consumidos para efetiva-lo.
   
1. [Follow - up da acima] Qual seriam os impactos de um sistema com apenas 2 camadas? E apenas 1? <br>
um sistema com duas camadas é pouco diferente de um sistema com mais do que duas camadas. a parte crítica é protegida na camada interior e os aplicativos são mantidos na exterior. <br>
com uma camada, não há separação entre a parte crítica e os aplicativos.

1. [Follow - up da acima] Como garantimos que apenas o SO execute na camada 0? <br>
o so é inicializado com o valor correspondente à camada 0 no registrador correspondente a este controle. daí, todo aplicativo é inicializado com o valor correspondente à camada 3 -e os drivers, camadas 2 e 1-. somente o so pode definir estes valores. em hardware, a cpu é construída de tal forma que somente instruções solicitadas da camada 0 sejam executadas. 

1. Qual a diferença entre Traps e Interrupções? <br>
uma interrupção é a interrupção do fluxo de processamento previsto causada por um sinal de controle assíncrono. <br>
uma trap é uma interrupção causada por um sinal emitido pelo próprio processador.

## Processos e Threads

1. [Silberschatz 3.8] Qual a diferença entre escalonamento de curto prazo, médio prazo e longo prazo?
longo: balancear a carga entre os processadores; <br>
médio: reduzir transferências de dados de processos entre memória e disco; <br>
curto: aumentar a responsividade dos processos ativos.

1. Como é feita a troca de contexto entre 2 processos? <br>
o estado do processo A é armazenado e o estado do processo B transferido ao processador.

1. Considera uma máquina sem múltiplos processadores (cores). Aqui, existem vantagens em usar threads? <br>
caso os processos usem e/s, sim.

1. Em quais momentos um processo pode passar do estado RUNNING (Em Execução) para o estado WAITING (Em Espera)? <br>
quando este acessa e/s.

1. O Linux mantém um um novo estado de processos indicando que o mesmo não pode ser interrompido. Qual a vantagem deste novo estado? <br>
este estado garante que o processo seja concluído tão rápido quanto permitido por suas operações.

1. Você consegue pensar em algum motivo pelo qual executamos um `fork` sem seguir um `exec`? <br>
pode ser conveniente quando a tarefa executada pelo novo processo é simples o suficiente para não demandar a execução de outro processo.

1. [Silberschatz 4.8 - Alterada] Pensando no estado de um processo, assum que um processo qualquer cria uma thread. Quais informações são compartilhadas com a threads? Quais não são? <br>
são compartilhados o id do processo, seu espaço de endereçamento e posse de recursos do sistema.

1. Qual a diferença entre paralelismo de dados e de processos? <br>
não são compartilhados o conteúdo dos registradores, região de stack e id de thread.

## Escalonamento

1. [Silberschatz 6.2] Qual a diferença entre escalonamento com interrupções e sem interrupções? <br>
o escolamento com interrupções pode alterar o estado de um programa de **executando** para **pronto**. no escalonamento sem interrupções, por outro lado, um processo só pode passar de **executando** para **concluído** ou **esperando**.

1. [Silberschatz 6.10 - Alterado] Como vimos em aula, o tempo de execução (CPU) e o tempo de espera (IO) afetam a prioridade de um processo. Qual a importância de separar os 2 tempos? <br>
separar os dois tempos permite otimizar o algoritmo de escalonamento para que cada processo só tenha posse da cpu quando for a utilizar.

1. Explique as métricas de avaliação de algoritmos de escalonamento.
   * Throughput: quantidade de processos concluídos por unidade de tempo
   * Turnaround time (tempo de término): tempo médio entre criação e conclusão dos processos
   * Tempo de Espera: tempo total pelo qual o processo esteve em espera
   * Tempo de Resposta: tempo entre criação e primeira execução do processo

1. Seguindo na questão anterior, seria possível maximizar todas as métricas de uma só vez? <br>
sim. basta aumentar a velocidade e quantidade de núcleos do processador :)

1. [Silberschatz 6.16] Considere o conjunto de processos a seguir. Na tabela, <br>
mostramos a duração de pico de CPU de cada processo em milissegundos:
   | Processo| Duração do Pico | Prioridade |
   | --------|-----------------|------------|
   | P1      | 2               | 2          |
   | P2      | 1               | 1          |
   | P3      | 8               | 4          |
   | P4      | 4               | 2          |
   | P5      | 5               | 3          |
Assuma que todos os processos chegaram em ordem (P1 até P5) no tempo 0. Desenhe gráficos de Gantt ilustrando a execução dos processos quando utilizamos: (a) FCFS; (b) SJF; (c) RR com quantum=2; <br>
   a) 0: P1 [00-02(02/02)] P2 [02-03(01/01)] P3 [03-11(08/08)] P4 [11-15(04/04)] P5 [15-20(05/05)] <br>
   b) 0: P2 [00-01(01/01)] P1 [01-03(02/02)] P4 [03-07(04/04)] P5 [07-12(05/05)] P3 [12-20(08/08)] <br>
   c) 0: P1 [00-02(02/02)] P2 [02-03(01/01)] P3 [03-05(02/08)] P4 [05-07(02/04)] P5 [07-09(02/05)] P3 [09-11(04/08)] P4 [11-13(04/04)] P5 [13-15(04/05)] P3 [15-17(06/08)] P5 [17-18(05/05)] P3 [18-20(08/08)]

1. Para cada processo. Compute as métricas da questão anterior. <br>
   * Throughput                        |  0.25 |  0.25 |  0.25
   * Turnaround time (tempo de término)|  10.2 |  08.6 |  11.2
   * Tempo de Espera
   * Tempo de Resposta
     
1. Você foi contratado para desenvolver um algoritmo de escalonamento para um sistema operacional (SO) de uso específico, que será executado em máquinas multiprocessadas. Esse SO será utilizado para operar uma plataforma de busca similar ao Google. Os processos que ele gerenciará estão divididos em três grupos principais: um grupo será responsável por coletar páginas da web, outro será encarregado de servir essas páginas para os clientes via Web, e o último grupo será dedicado ao processamento e indexação das páginas. <br>
Como é possível observar, alguns desses processos apresentam uma maior demanda de I/O, enquanto outros são mais intensivos em uso de CPU. Diante desse cenário, como você estruturaria as filas de prioridade para esses diferentes tipos de processos? Quais algoritmos de escalonamento você utilizaria dentro dessas filas? Além disso, você considera necessário permitir que os processos possam migrar entre diferentes filas ao longo do tempo? <br>
Uma fila para cada grupo;  
RR, RR e FCFS, respectivamente;  
Não é necessário migrar os processos entre as filas, já que cada um trata de uma parte especifica da tarefa.

## Sincronização e Deadlocks

1. Qual o menor programa que você consegue escrever que gera um deadlock?
```c
int main() {
   while(1);
   return 0;
}
```
1. Faz sentido ter um programa com várias threads que precisa de sincronização constante? <br>
depende do que é "constante". se for sincronizar em todas as instruções, basta uma thread para não fazer sentido. se for sincronizar com alta frequência, pode não ser eficiente, mas é plausível.

1. A chamada `thread_yield` faz com que uma thread libere o uso de CPU para outra thread/processo. Em quais situações a mesma é útil? Como ela difere de mutexes? <br>
pode ser útil em processos que consumam muito tempo de cpu, mas não sejam prioritarias em uma política que não usa round robin. o processo pode ceder a cpu em alguns pontos de controle. é diferente de mutexes porque cede a cpu imediatamente, enquanto estes controlam o acesso a partes específicas do programa.

1. Como podemos implementar um semáforo contador a partir de um semáforo binário?
```c
typedef struct {
    int count;
    pthread_mutex_t binary_semaphore;
} counting_semaphore_t;

void counting_semaphore_init(counting_semaphore_t *sem, int initial_count) {
    sem->count = initial_count;
    pthread_mutex_init(&sem->binary_semaphore, NULL);
}

void counting_semaphore_wait(counting_semaphore_t *sem) {
    pthread_mutex_lock(&sem->binary_semaphore);
    while (sem->count <= 0) {
        pthread_mutex_unlock(&sem->binary_semaphore);
        // Busy wait
        pthread_mutex_lock(&sem->binary_semaphore);
    }
    sem->count--;
    pthread_mutex_unlock(&sem->binary_semaphore);
}
```
1. Existem três requisitos para o problema da seção crítica. Explique os mesmos e motivos pelos quais precisamos dos três. <br>
exclusão mútua: garantir que apenas um processo possa estar na seção crítica de cada vez. é crucial para evitar condições de corrida, onde múltiplos processos acessam e modificam dados compartilhados simultaneamente, o que pode levar a resultados inconsistentes ou corrompidos. <br>
progresso: assegura que, se nenhum processo está na seção crítica e existem processos que desejam entrar, algum desses processos deve ser permitido entrar na seção crítica. garante que o sistema não entre em um estado de inatividade onde processos que precisam acessar a seção crítica ficam indefinidamente esperando, mesmo quando a seção crítica está disponível. <br>
espera limitada: estabelece um limite no número de vezes que outros processos podem entrar na seção crítica depois que um processo expressou o desejo de entrar na seção crítica e antes de ser permitido a entrada. evita a inanição, garantindo que todos os processos eventualmente terão acesso à seção crítica, prevenindo que um processo seja perpetuamente adiado.

1. Message Passing Interface (MPI) é um sistema de troca de mensagens bastante utilizado para o desenvolvimento de aplicações de cluster. O mesmo define duas primitivas simples de `send` e `receive` para a troca de dados entre `n > 1` processos. Em algumas implementações de MPI, sempre que um processo chama `receive`, MPI espera por dados em um *spinlock* (ou seja, uma espera ocupada). Quais a vantagens de utilizar o spinlock e não outro mecanismo que libera a CPU? <br>
quando a espera é curta, é mais eficiente manter a posse da cpu do que fazer multiplas trocas de contexto

1. Em sala de aula falamos que podemos resolver o problema dos filósofos com
   um garçom. Explique como implementar tal garçom. Quais são as vantagens e
   desvantagens desta solução?

## Memória: Hardware

1. [Silberschatz 8.1] Qual a diferença entre endereços lógicos e físicos? <br>
Cada processo tem acesso a 2<sup>n</sup> endereços virtuais, tal que n é o tamanho, em bits, da palavra na arquitetura. Estes endereços, os lógicos, são particulares do processo e não correspondem, diretamente, aos endereços físicos. Endereços físicos são os acessados na memória física pelo hardware e parte do software de inicialização do SO.

1. [Silberschatz 8.3] Por que os tamanhos de página sempre são potência de 2? <br>
Para facilitar a decodificação e o controle de acesso bit-a-bit.

1. Cite 2 vantagens de utilizar endereçamento hierárquico? <br>
1 - Menor espaço alocado para paginação; <br>
2 - Maior isolamento entre processos

1. Qual o tamanho máximo de memória física possível em um sistema de 32 bits? <br>
2<sup>32</sup> = 4 GB <br>
E em um de 64 bits?
2<sup>64</sup> = 16 EB

1. [Tanenbaum 3.4] Considere um sistema de troca de processos entre memória e disco no qual a memória é constituída de lacunas em ordem na memória: 10 KB, 4 KB, 20KB, 18KB, 7KB,  9KB, 12KB e 15KB. Qual lacuna é ocupada quando solicitamos de forma sucessiva: 12, 10 e 9 KB respectivamente? Use os algoritmos: first fit, best fit, worst fit e next fit.

   | BLOCO [KB] 	| 10 	| 4 	| 20 	| 18 	| 7 	| 9 	| 12 	| 15 	|
   |------------	|---:	|--:	|---:	|---:	|--:	|--:	|---:	|---:	|
   | FIRST      	| 10 	|   	| 12 	|  9 	|   	|   	|    	|    	|
   | BEST       	| 10 	|   	|    	|    	|   	| 9 	| 12 	|    	|
   | WORST      	|    	|   	| 12 	| 10 	|   	|   	|    	|  9 	|
   | NEXT       	|    	|   	| 12 	| 10 	|   	| 9 	|    	|    	|

1. [Tanenbaum 3.18] Uma máquina tem um endereçamento virtual de 48 bits e um endereçamento físico de 32 bits. As páginas são de 8KB. Quantas entradas são necessárias na tabela de páginas? <br>
VPN<sub>bits</sub> = 48 - log(8·2<sup>10</sup>) = 35 &rarr; 2<sup>35</sup> entradas

1. [Silberschatz 8.13] Compare os esquemas de alocação contígua, segmentação pura e paginação pura com relação às questões a seguir:
   1. Fragmentação externa
   2. Fragmentação interna
   3. Compartilhamento

   | Questão              | Alocação Contígua | Segmentação Pura | Paginação Pura  |
   |----------------------|-------------------|------------------|-----------------|
   | Fragmentação Externa | Alta              | Moderada         | Nenhuma         |
   | Fragmentação Interna | Baixa             | Nenhuma          | Moderada        |
   | Compartilhamento     | Difícil           | Facilitado       | Muito eficiente |

1. [Silberschatz 8.15] Explique por que sistemas operacionais móveis como iOS e Android não suportam permuta? <br>
A ausência de suporte à permuta em iOS e Android é uma decisão técnica baseada em otimização de desempenho, preservação da vida útil do armazenamento flash e alinhamento com os requisitos de dispositivos móveis, que priorizam responsividade, eficiência energética e simplicidade no gerenciamento de memória.

1. [Siberschatz 8.20] Supondo um tamanho de página de 1KB (2^10, com 2^22 bits para tradução). Quais são os números de deslocamentos de página para as referências a seguir (fornecidas como decimais):
   1. 3085 &rarr; 3
   2. 42095 &rarr; 41
   3. 215201 &rarr; 210
   4. 650000 &rarr; 634
   5. 200001 &rarr; 195


1. [Siberschatz 8.24] Considera um sistema de computação com um endereço lógico de 32 bits e tamanho de página de 4KB. O sistema de 512MB de memória física. Quantas entradas haveria em cada um dos itens a seguir:
   1. Tabela de páginas de um único nível &rarr; 2<sup>20</sup> entradas
   1. Tabela de páginas de dois níveis &rarr; depende de como o VPN é dividido. sejam D a quantidade de bits alocada para endereçamento no diretório, T a quantidade de bits alocada para endereçamento na tabela, nD a quantidade de diretórios alocados e nT a quantidade de tabelas alocadas para os processos em execução. nD·2<sup>D</sup> + nT·2<sup>T</sup> entradas
   1. Tabela hash &rarr; 2<sup>20</sup> entradas

1. [Siberschatz 8.25] Considera um sistema de paginação simples:
   1. Se uma referência para a memória gasta 50ns, quanto tempo leva uma referência para a memória paginada. &rarr; 50 ns (busca do endereço da página na memória) + 50 ns (acesso ao endereço real na página) = 100 ns
   1. Se a TLB tem 75% de acerto, qual será o tempo efetivo de acesso à memória? (Assuma que a TLB tem um custo de 2ns) &rarr; 0.75·(2 + 50) + 0.25·(2 + 50 + 50) = 64.5 ns

1. [Siberschatz 8.29] Qual a finalidade da paginação da tabela de páginas? <br>
A tabela de páginas em memória gerenciada por sistema operacional serve para mapear os endereços de memória virtual para os endereços de memória física, permitindo a alocação não contígua da memória. Isso melhora a eficiência do uso da memória, evita a fragmentação externa, garante o isolamento de processos e possibilita técnicas como a troca de páginas entre a memória física e o disco. A tabela de páginas facilita o acesso rápido e seguro à memória, otimizando o desempenho do sistema.

1. [Tanenbaum 3.10] Suponha que uma máquina tenha endereços virtuais de 48 bits e endereços físicos de 32 bits.
   1. Se as páginas são de 4KB, quantas entradas existem na tabela de páginas se a mesma for de 1 nível? 48 - 12 = 36 bits &rarr; 2<sup>36</sup> entradas
   1. Suponha que o mesmo sistema tenha uma TLB com 32 entradas. Assumindo um tempo de acesso de 10ns para a memória real e 2ns para a TLB, qual a eficácia do sistema? TMA = 12(1 - f<sub>TLB</sub>) + 22f<sub>TLB</sub>

## Memória: SO

1. [Siberschatz 9.1 - Resumida] Quando ocorrem os erros/faltas de pagina? Quais são os passos do SO para tratar as mesmas? <br>
Erros de página ocorrem quando um processo tenta acessar uma página de memória que não está presente na RAM, geralmente porque foi movida para o disco. O sistema operacional trata esses erros carregando a página faltante da memória secundária (disco) para a RAM, atualizando a tabela de páginas e, se necessário, substituindo outras páginas na memória. Esse processo envolve a verificação da validade da página, a alocação de espaço na RAM e a atualização dos dados, permitindo que o processo continue sua execução após a página ser carregada.

1. [Siberschatz 9.7 - Alterada] Considere o array bidimensional `A`: `int A[][] = new int[100][100]`. O programa inteiro (texto) que processa a matriz reside na página 0. Com 3 quadros de memória real e assumindo que cada linha da matriz cabe em 1 página, quantas faltas ocorrem ao ler a matriz das seguintes forma em um acesso FIFO:
```c
for (int i = 0; i < 100; i++)
      for (int j = 0; j < 100; j++)
         // Lê A[i][j]
```
Assumindo que a alocação do array preenche a memória de forma ótima, quando a iteração começa, `A[0]`, `A[1]` e `A[2]`já estão na RAM. As demais linhas são buscadas conforme acessadas pelo programa. Por isso, 97 segfaults acontecem. 

```c
for (int j = 0; j < 100; j++)
      for (int i = 0; i < 100; i++)
         // Lê A[i][j]
```
Assumindo que a alocação do array preenche a memória de forma ótima, `A[0][0]`, `A[1][0]` e `A[2][0]` já estão na memória. Daí, seguem 97 segfaults, `i = 3:99`. Quando `j` incrementa, estão, na memória, `A[97]`, `A[98]` e `A[99]`. Por isso, todos os 98·100 acessos seguintes geram segfaults. No total, são 98097 segmentation faults.

1. [Siberschatz 9.10 - Alterada] Em um algoritmo ótimo pode ocorrer a anomalia de belady? <br>
Não, já que um algoritmo ótimo sempre faz a melhor alocação possível e a melhor alocação possível é sempre facilitada por uma maior quantidade de quadros.

1. [Siberschatz 9.17 - Resumida] Quais as vantagens do copy on write? Como o SO e o hardware podem implementar o mesmo? <br>
A estratégia copy-on-write tem a vantagem de consumir uma quantidade fixa e pequena de memória na cópia de um quadro que não recebe escrita, independentemente de seu tamanho. Sua implementação consistem em replicar somente o cabeçalho que contém as informações referentes a tal quadro.

1. [Tanenbaum 3.20 - Reformulada] Imagine um compilador que vai observar todos os acessos de memória do código, gerando como saída as páginas que devem ser substituídas para implementar uma política de troca de páginas ótima. É possível gerar tal compilador? Explique por quê. O mesmo funciona quando o algoritmo de troca de páginas é global? <br>
É teoricamente possível criar um compilador que analise todos os acessos à memória de um programa para implementar uma política de troca de páginas ótima, como a de Belady, determinando as páginas a serem substituídas. No entanto, isso exige conhecimento completo dos acessos futuros, o que é inviável em programas reais com entradas dinâmicas ou interações imprevisíveis. Para algoritmos globais, que envolvem múltiplos processos, a complexidade cresce ainda mais, pois seria necessário prever o comportamento de todos os processos simultaneamente, tornando a abordagem impraticável.

1. [Tanenbaum 3.22] Se o algoritmo FIFO é usado com quatro molduras de página e oito páginas virtuais, quantas faltas vão ocorrer para a sequência de acessos `01723277103`. Repita para LRU. <br>

| Passo | Acesso | Molduras (FIFO) | Falta? (FIFO) | Molduras (LRU) | Falta? (LRU) |
|-------|--------|-----------------|---------------|----------------|--------------|
| 1     | 0      | 0               | Sim           | 0              | Sim          |
| 2     | 1      | 0 1             | Sim           | 0 1            | Sim          |
| 3     | 7      | 0 1 7           | Sim           | 0 1 7          | Sim          |
| 4     | 2      | 0 1 7 2         | Sim           | 0 1 7 2        | Sim          |
| 5     | 3      | 3 1 7 2         | Sim           | 3 1 7 2        | Sim          |
| 6     | 2      | 3 1 7 2         | Não           | 3 1 7 2        | Não          |
| 7     | 7      | 3 1 7 2         | Não           | 3 1 7 2        | Não          |
| 8     | 7      | 3 1 7 2         | Não           | 3 1 7 2        | Não          |
| 9     | 1      | 3 1 7 2         | Não           | 3 1 7 2        | Não          |
| 10    | 0      | 3 0 7 2         | Sim           | 0 1 7 2        | Sim          |
| 11    | 3      | 3 0 7 2         | Não           | 0 1 7 3        | Sim          |

1. Um computador pequeno tem quatro molduras de página. No primeiro tique do relógio os bits R são `0111`. Os próximos tiques são: `1011`, `1010`, `1101`, `0010`, `1010`, `1100` e `0001`. Se o algoritmo de envelhecimento, aging, é usado com um contador de 8 bits. Quais os valores dos quatro contadores após o último tique.

   | Quadro 0 | Quadro 1 | Quadro 2 | Quadro 3 |
   |----------|----------|----------|----------|
   | 10000000 | 10000000 | 10000000 | 00000000 |
   | 11000000 | 11000000 | 01000000 | 10000000 |
   | 01100000 | 11100000 | 00100000 | 11000000 |
   | 10110000 | 01110000 | 10010000 | 11100000 |
   | 01011000 | 10111000 | 01001000 | 01110000 |
   | 00101100 | 11011100 | 00100100 | 10111000 |
   | 00010110 | 01101110 | 10010010 | 11011100 |
   | 10001011 | 00110111 | 01001001 | 01101110 |

1. [Tanenbaum 3.28] Um computador tem quatro molduras de página. O tempo de carregamento da página na memória, o instante do último acesso e os bits `R e M` para cada página são mostrados a seguir:

   | Página | Carregado | Última ref. | R | M |
   |--------|-----------|-------------|---|---|
   | 0      | 126       | 280         | 1 | 0 |
   | 1      | 230       | 265         | 0 | 1 |
   | 2      | 140       | 270         | 0 | 0 |
   | 3      | 110       | 285         | 1 | 1 |

   1. Qual página será trocada pelo NRU? &rarr; 2
   1. FIFO? &rarr; 3
   1. LRU &rarr; 1
   1. Segunda chance? &rarr; 2

1. [Silberschatz 9.14] Suponha que um programa tenha acabado de referenciar um endereço na memória virtual. Descreve se e qual o motivo de cada cenário ocorrer: <br>
   a. Falta na TLB sem falta na tabela de páginas: A TLB não tem a entrada, mas a tabela de páginas possui a tradução na memória física.
   b. Falta na TLB com falta na tabela de páginas: Nem a TLB nem a tabela de páginas têm a entrada; ocorre uma falta de página.
   c. Sucesso na TLB sem falta de página na tabela: A TLB tem a entrada, e a página está na memória física.
   d. Sucesso na TLB com falta de página na tabela: Impossível, pois a TLB depende de uma entrada válida na tabela de páginas.

## Entrada e Saída

1. Existem cenários onde o POOLING é útil? Explique quais.

1. [Silberschatz 13.5] Como DMA aumenta a concorrência no sistema? Como
   ele complica o projeto de hardware?

1. [Silberschatz 13.9 - Alterada] Quais as vantagens de registradores de
   controle de dispositivos?

1. Faz sentido um dispositivo que tem controle com base em registradores
   e não faz uso de DMA?

1. [Silberschatz 13.12] Quais são os overheads de atender uma interupção?

1. Existem algum momento que é melhor usar I/O com pooling?

## Discos

1. Geralmente o scheduling do disco é jogado com tarefa do SO. Você
   consegue explicar os motivos?

1. [Siberschatz 10.1] O scheduling de disco, com execução de FCFS, é
   útil em um ambiente monousuário? Explique sua resposta.

1. [Silberschats 10.2] Explique por que o SSTF tende a favorecer o
   o "meio do disco".

1. Explique o motivo pelo qual FCFS é o único algoritmo justo de
   disco.

## Arquivos

1. Dê exemplos de aplicaçes que fazem uso de acesso sequencial.
   E de acesso randômico?

1. Faz sentido o SO ter um cache dos últimos arquivos abertos?
   Isto é, um cache de inodes->dados.

1. [Silberschatz 11.14] Se o sistema operacional souber que
   determinada aplicação vai fazer uso dos dados de um arquivo,
   domo tal informação pode ser explorada por desempenho?

1. Discuta e compara hard links e soft links em quesitos de
   vantagens e desvantagem.

## Sistema de Arquivos

1. [Tanenbaum 5.1 - Inspirada] Existem vantagens em identificar arquivos
   executáveis com um número mágico fixo? Quais as desvantagens?

1. [Tanenbaum 5.3 - Inspirada] É possível ter um SO que permite
   ler e escrever de arquivos sem uma chamada `open` (isto é, fazer um
   `read` direto), quais são as vantagens e desvantagens de tal
   abordagem?

1. [Tanenbaum 5.6 - Inspirada] Bole um mecanismo de comunicação entre
   processos utilizando `mmaps`. Você precisa mapear o arquivo inteiro
   em cada processo?

1. [Tanenbaum 5.11]

1. Quais são as vantagens e desvantagens de guardar i-nodes perto dos
   arquivos?

1. [Tanenbaum 5.33] Considerando um sistema de arquivos estilo FFS,
   no pior caso, quantas operaçes de ler i-nodes são necessárias
   para ler `/home/user/cursos/so/tp2.c`.

1. [Siberschatz 12.2] Qual são os motivos de manter o mapa de
   bits do sistema de arquivos no disco e não na memória?

1. [Silberschatz 12.6] Como os caches ajudam a melhora o desempenho?
   Por que sistemas não usam caches maiores ou em maior número?

1. Explique como funciona uma camada de arquivos virtual.

1. Explique qual o motivo de se utilizar inodes. Quais informações
   guardamos em iNodes geralmente?

1. Explique quais são as vantagens de inodes indireto.

1. Pensando em um disco em cilindro, como você faria a alocação de
   diretórios para ter um melhor desempenho? Como lidar com arquivos
   grandes.

1. [Silberschatz 12.13 - Inspirada] Similar a memória principal,
   sistemas de arquivos tem que escolher um tamanho de bloco. Quais
   são as vantagens e desvantagens de um tamanho de bloco maior ou
   menor. Existem vantagens e ter 2 tamanhos para um mesmo sistema
   de arquivos?

## Proteção e Segurança

São poucos problemas de proteção e segurança no livro, deem uma olhada
neles.
