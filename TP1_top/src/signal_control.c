#include "signal_control.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <pthread.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/syscall.h>
#include <sys/stat.h>
#include <dirent.h>
#include <errno.h>
#include <time.h>
#include <signal.h>
#include <pwd.h>

#include "str_to_pid.h"

/*
  function to convert string with signal name to signal
  receives: str - string to convert
  returns: signal or -1 if error
*/
int str_signal_to_signal(const char *str)
{
  if (strcmp(str, "SIGKILL") == 0) {
    return SIGKILL;
  } else if (strcmp(str, "SIGSTOP") == 0) {
    return SIGSTOP;
  } else if (strcmp(str, "SIGCONT") == 0) {
    return SIGCONT;
  } else if (strcmp(str, "SIGTERM") == 0) {
    return SIGTERM;
  } else if (strcmp(str, "SIGUSR1") == 0) {
    return SIGUSR1;
  } else if (strcmp(str, "SIGUSR2") == 0) {
    return SIGUSR2;
  } else {
    return -1;
  }
}

/*
  function to convert string integer to signal
  receives: str - string to convert
  returns: signal or -1 if error
*/
int str_int_to_signal(const char *str)
{
  char *endptr;

  int sig = strtol(str, &endptr, 10);

  if (endptr == str || *endptr != '\0') {
    return -1;
  }

  return sig;
}

/*
  function to convert string integer to signal string
  receives: str - string to convert
  returns: signal string or NULL if error
*/
char* str_int_to_str_signal(const char *str)
{

  int sig = str_int_to_signal(str);

  if (sig == -1) {
    return NULL;
  }

  switch (sig) {
    case SIGKILL:
      return "SIGKILL";
    case SIGSTOP:
      return "SIGSTOP";
    case SIGCONT:
      return "SIGCONT";
    case SIGTERM:
      return "SIGTERM";
    case SIGUSR1:
      return "SIGUSR1";
    case SIGUSR2:
      return "SIGUSR2";
    default:
      return NULL;
  }
}

/*
  function to send a signal to a process
  receives: pid - process id
            sig - signal
  returns: success or failure
*/
int send_signal(const pid_t pid, const int sig)
{
  if (kill(pid, sig) == -1) {
    perror("kill");
    return -1;
  }

  return 0;
}

/*
  function to convert input to signal
  receives: input - input to convert
  returns: signal or -1 if error
*/
int input_to_signal(const char *input)
{
  int sig;

  sig = str_signal_to_signal(input);
  if (sig == -1) {
    sig = str_int_to_signal(input);
  }

  return sig;
}
