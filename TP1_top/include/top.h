#ifndef TOP_H
#define TOP_H

#include "process_monitor.h"
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
#include <termios.h>
#include <stdatomic.h>

#include "str_to_pid.h"

#define MAX_INPUT_BUFFER_SIZE 512

/*
  function to setup terminal so that input is preserved between output clears
  receives: void
  returns: void
*/
int setup_terminal_for_input_and_output();

/*
  function to call print_processes each time_s seconds (a thread)
  receives: args - arguments to pass to print_processes
                    time_s - time to wait between prints
                    n - number of processes to print
  access: input_buffer (shared, read)
  returns: void
*/
void monitor_processes(monitor_processes_args *args);

/*
  function to read input, convert it and send signal (a thread)
  receives: void
  access: input_buffer (shared, write)
  returns: void
*/
void control_signals();

/*
  function to process the input buffer
  receives: buffer - buffer to process
  access: input_buffer (shared, read and write)
  returns: success or failure
*/
int process_input();

#endif // TOP_H
