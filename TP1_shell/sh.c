#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <assert.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>

/* MARK NAME Seu Nome Aqui */
/* MARK NAME Nome de Outro Integrante Aqui */
/* MARK NAME E Etc */

/****************************************************************
 * Shell xv6 simplificado
 *
 * Este codigo foi adaptado do codigo do UNIX xv6 e do material do
 * curso de sistemas operacionais do MIT (6.828).
 ***************************************************************/

#define MAXARGS 10

/* Todos comandos tem um tipo.  Depois de olhar para o tipo do
 * comando, o código converte um *cmd para o tipo específico de
 * comando. */
struct cmd {
  int type; /* ' ' (exec)
               '|' (pipe)
               '<' or '>' (redirection) */
};

struct execcmd {
  int type;              // ' '
  char *argv[MAXARGS];   // argumentos do comando a ser exec'utado
};

struct redircmd {
  int type;          // < ou > 
  struct cmd *cmd;   // o comando a rodar (ex.: um execcmd)
  char *file;        // o arquivo de entrada ou saída
  int mode;          // o modo no qual o arquivo deve ser aberto
  int fd;            // o número de descritor de arquivo que deve ser usado
};

struct pipecmd {
  int type;          // |
  struct cmd *left;  // lado esquerdo do pipe
  struct cmd *right; // lado direito do pipe
};

int fork1(void);  // Fork mas fechar se ocorrer erro.
struct cmd *parsecmd(char*); // Processar o linha de comando.

/* Executar comando cmd.  Nunca retorna. */
void
runcmd(struct cmd *cmd)
{
  int p[2];
  struct execcmd *ecmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    exit(0);
  
  switch(cmd->type){
  default:
    fprintf(stderr, "tipo de comando desconhecido\n");
    exit(-1);

  case ' ':
    ecmd = (struct execcmd*)cmd;
    if(ecmd->argv[0] == 0)
      exit(0);
    /* MARK START task2
     * TAREFA2: Implemente codigo abaixo para executar
     * comandos simples. */

    /*
    fork: cria um processo filho
          retorna 0 para o processo filho
          retorna o PID do processo filho para o processo pai
    */
    if (fork() == 0) {
      /*
      execvp: substitui a imagem do processo atual (filho) por um novo processo,
                dado pelo nome do arquivo e uma lista de argumentos
              recebe o nome do arquivo e um vetor de strings com os argumentos
              retorna -1 se falhar      
      */
      if (execvp(ecmd->argv[0], ecmd->argv) < 0) {
        fprintf(stderr, "execvp falhou\n");
        exit(-1);
      }
    } else {
      /*
      wait: coloca o processo pai em espera até a próxima conclusão de um processo filho
      */
      wait(NULL);
    }

    /* MARK END task2 */
    break;

  case '>':
  case '<':
    rcmd = (struct redircmd*)cmd;
    /* MARK START task3
     * TAREFA3: Implemente codigo abaixo para executar
     * comando com redirecionamento. */

    /*
    open: abre um arquivo
          recebe o nome do arquivo, o modo de abertura e as permissões
            S_IRWXU: permissões de leitura, escrita e execução para o dono
          retorna o descritor de arquivo do arquivo aberto
          retorna -1 se falhar    
    */
    int fd = open(rcmd->file, rcmd->mode, S_IRWXU);
    if (fd < 0) {
      fprintf(stderr, "não pode abrir %s\n", rcmd->file);
      exit(-1);
    }
    /*
    dup2: faz com que rcmd->fd receba os atributos fd e seus acessos
            e com as mesmas permissões
          recebe o descritor de arquivo original e o descritor de arquivo destino
          retorna -1 se falhar
    */
    if (dup2(fd, rcmd->fd) < 0) {
      fprintf(stderr, "dup2 falhou\n");
      exit(-1);
    }
    /*
    close: fecha o descritor de arquivo
           recebe o descritor de arquivo
           não é necessário fechar rcmd->fd, pois o arquivo já foi fechado por fd
    */
    close(fd);

    /* MARK END task3 */
    runcmd(rcmd->cmd);
    break;

  case '|':
    pcmd = (struct pipecmd*)cmd;
    /* MARK START task4
     * TAREFA4: Implemente codigo abaixo para executar
     * comando com pipes. */

    /*
    pipe: cria um pipe para comunicação entre processos
          recebe um vetor de inteiros com dois elementos,
            p[0]: descritor de arquivo para leitura
            p[1]: descritor de arquivo para escrita
          retorna -1 se falhar
    */
    if (pipe(p) < 0) {
      fprintf(stderr, "pipe falhou\n");
      exit(-1);
    }

    /*
    fork: cria um processo filho
          retorna 0 para o processo filho
          retorna o PID do processo filho para o processo pai
    
    */
    if (fork() == 0) {
      /*
      close: cada processo tem sua própria saída padrão (descritor de arquivo 1)
             libera o descritor da saída padrão do processo filho
      */
      close(1);
      /*
      dup: faz com que p[1] receba os atributos do menor descritor de arquivo disponível,
            1, a saída padrão, e seus acessos
           daí, o que for escrito na saída padrão será escrito em p[1]
      */
      dup(p[1]);
      /*
      close: libera os descritores de arquivo que não serão utilizados
      */
      close(p[0]);
      close(p[1]);
      /*
      runcmd: executa, recursivamente, o comando à esquerda do pipe
                como runcmd não retorna, este processo não executará o código abaixo
      */
      runcmd(pcmd->left);
    }

    /*
    fork: cria um processo filho
          retorna 0 para o processo filho
          retorna o PID do processo filho para o processo pai
    */
    if (fork() == 0) {
      /*
      close: cada processo tem sua própria entrada padrão (descritor de arquivo 0)
             libera o descritor da entrada padrão do processo filho
      */
      close(0);
      /*
      dup: faz com que p[0] receba os atributos do menor descritor de arquivo disponível,
            0, a entrada padrão, e seus acessos
           daí, o que for lido na entrada padrão será lido de p[0]
      */
      dup(p[0]);
      /*
      close: libera os descritores de arquivo que não serão utilizados
      */
      close(p[1]);
      close(p[0]);
      /*
      runcmd: executa, recursivamente, o comando à direita do pipe
                como runcmd não retorna, este processo não executará o código abaixo
      */
      runcmd(pcmd->right); 
    }

    /*
    close: libera os descritores de arquivo, que não são utilizados pelo processo pai
    */
    close(p[0]);
    close(p[1]);

    /*
    wait: aguarda a conclusão dos processos filhos
    */
    wait(NULL);
    wait(NULL);
    
    /* MARK END task4 */
    break;
  }    
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
  if (isatty(fileno(stdin)))
    fprintf(stdout, "$ ");
  memset(buf, 0, nbuf);
  fgets(buf, nbuf, stdin);
  if(buf[0] == 0) // EOF
    return -1;
  return 0;
}

int
main(void)
{
  static char buf[100];
  int r;

  // Ler e rodar comandos.
  while(getcmd(buf, sizeof(buf)) >= 0){
    /* MARK START task1 */
    /* TAREFA1: O que faz o if abaixo e por que ele é necessário?
     * Insira sua resposta no código e modifique o fprintf abaixo
     * para reportar o erro corretamente. */
    /* RESPOSTA: O if abaixo verifica se o comando é um comando de mudança de diretório.
     * Se for, ele muda o diretório de trabalho do shell para o diretório especificado.
     * É necessário verificar o comando 'cd' antes de avaliar os demais comandos porque
     * 'cd' é um comando interno do shell que altera o diretório de trabalho do processo
     * atual. Se não tratarmos 'cd' de forma especial, ele seria passado para a função
     * fork1() e runcmd(), que tentariam executá-lo como um comando externo, o que não
     * funcionaria corretamente.
    */
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      buf[strlen(buf)-1] = 0;
      if(chdir(buf+3) < 0)
        fprintf(stderr, "não pode mudar para %s\n", buf+3);
      continue;
    }
    /* MARK END task1 */

    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait(&r);
  }
  exit(0);
}

int
fork1(void)
{
  int pid;
  
  pid = fork();
  if(pid == -1)
    perror("fork");
  return pid;
}

/****************************************************************
 * Funcoes auxiliares para criar estruturas de comando
 ***************************************************************/

struct cmd*
execcmd(void)
{
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = ' ';
  return (struct cmd*)cmd;
}

struct cmd*
redircmd(struct cmd *subcmd, char *file, int type)
{
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = type;
  cmd->cmd = subcmd;
  cmd->file = file;
  cmd->mode = (type == '<') ?  O_RDONLY : O_WRONLY|O_CREAT|O_TRUNC;
  cmd->fd = (type == '<') ? 0 : 1;
  return (struct cmd*)cmd;
}

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = '|';
  cmd->left = left;
  cmd->right = right;
  return (struct cmd*)cmd;
}

/****************************************************************
 * Processamento da linha de comando
 ***************************************************************/

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
  case '|':
  case '<':
    s++;
    break;
  case '>':
    s++;
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return ret;
}

int
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
}

struct cmd *parseline(char**, char*);
struct cmd *parsepipe(char**, char*);
struct cmd *parseexec(char**, char*);

/* Copiar os caracteres no buffer de entrada, comeando de s ate es.
 * Colocar terminador zero no final para obter um string valido. */
char 
*mkcopy(char *s, char *es)
{
  int n = es - s;
  char *c = malloc(n+1);
  assert(c);
  strncpy(c, s, n);
  c[n] = 0;
  return c;
}

struct cmd*
parsecmd(char *s)
{
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
  cmd = parseline(&s, es);
  peek(&s, es, "");
  if(s != es){
    fprintf(stderr, "leftovers: %s\n", s);
    exit(-1);
  }
  return cmd;
}

struct cmd*
parseline(char **ps, char *es)
{
  struct cmd *cmd;
  cmd = parsepipe(ps, es);
  return cmd;
}

struct cmd*
parsepipe(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if(peek(ps, es, "|")){
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
  }
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a') {
      fprintf(stderr, "missing file for redirection\n");
      exit(-1);
    }
    switch(tok){
    case '<':
      cmd = redircmd(cmd, mkcopy(q, eq), '<');
      break;
    case '>':
      cmd = redircmd(cmd, mkcopy(q, eq), '>');
      break;
    }
  }
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|")){
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a') {
      fprintf(stderr, "syntax error\n");
      exit(-1);
    }
    cmd->argv[argc] = mkcopy(q, eq);
    argc++;
    if(argc >= MAXARGS) {
      fprintf(stderr, "too many args\n");
      exit(-1);
    }
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  return ret;
}

// vim: expandtab:ts=2:sw=2:sts=2

