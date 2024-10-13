#ifndef SIGNAL_CONTROL_H
#define SIGNAL_CONTROL_H

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

#define MAX_PATH_BUFFER_SIZE 512

/*
  function to convert string with signal name to signal
  receives: str - string to convert
  returns: signal or -1 if error
*/
int str_signal_to_signal(const char *str);

/*
  function to convert string integer to signal
  receives: str - string to convert
  returns: signal or -1 if error
*/
int str_int_to_signal(const char *str);

/*
  function to convert string integer to signal string
  receives: str - string to convert
  returns: signal string or NULL if error
*/
char* str_int_to_str_signal(const char *str);

/*
  function to convert input to signal
  receives: input - input to convert
  returns: signal or -1 if error
*/
int input_to_signal(const char *input);

/*
  function to send a signal to a process
  receives: pid - process id
            sig - signal
  returns: success or failure
*/
int send_signal(const pid_t pid, const int sig);

#endif // SIGNAL_CONTROL_H
