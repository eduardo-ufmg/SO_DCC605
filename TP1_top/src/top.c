#include "top.h"

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

atomic_int new_update = 0;
int terminal_is_configured = 0;

int setup_terminal_for_input_and_output()
{
  /*
  termios: structure that contains the terminal settings
           c_lflag: local modes
  */
  struct termios oldt, newt;
  /*
  tcgetattr: function to get the parameters associated with the terminal
             fd: file descriptor associated with the source of the parameters (stdin)
             termios_p: pointer to the structure that will receive the parameters
  */
  tcgetattr(STDIN_FILENO, &oldt);
  // copy the parameters to the new structure
  newt = oldt;
  /*
  the new settings is a copy of the old settings with the following changes:
  - ICANON: disable canonical mode (input is available line by line)
  - ECHO: disable echo (input is not displayed on the terminal)
  */
  newt.c_lflag &= ~ICANON;
  newt.c_lflag &= ~ECHO;
  /*
  tcsetattr: function to set the parameters associated with the terminal
             fd: file descriptor associated with the destination of the parameters (stdin)
             optional_actions: TCSANOW - changes are made immediately
             newt: structure with the new parameters
  */
  tcsetattr(STDIN_FILENO, TCSANOW, &newt);

  terminal_is_configured = 1;

  return 0;
}

void monitor_processes(monitor_processes_args *args)
{
  if (!terminal_is_configured)
  {
    setup_terminal_for_input_and_output();
  }

  while (1) {
    system("clear");
    print_processes(args->n);

    new_update = 1;

    sleep(args->time_s);
  }
}

/*
  function to read input asynchronously, while the output
  is constantly updated
  it reads the input character by character, appending it to a buffer
  the buffer is processed when the user presses enter
  and kept between updates, so the user can continue typing
  also, input is echoed to stdout and the buffer is also appended to stdout
  when a new update occurs
*/
void control_signals()
{
  char buffer[MAX_INPUT_BUFFER_SIZE];
  size_t buffer_index = 0;
  char ch;

  if (!terminal_is_configured)
  {
    setup_terminal_for_input_and_output();
  }

  while (1) {
    ch = getchar();

    if (ch != '\n') {
      #define DELETE_C 127

      if (ch == DELETE_C) {
        if (buffer_index > 0) {
          buffer[--buffer_index] = '\0';
        }
      } else if (buffer_index < sizeof(buffer) - 1) {
        buffer[buffer_index++] = ch;
        buffer[buffer_index] = '\0';
        printf("%c", ch);
      } else {
        printf("\nBuffer limit reached. Clearing buffer.\n");
        buffer_index = 0;
        buffer[0] = '\0';
      }
    } else {
      buffer[buffer_index] = '\0';
      
      if (process_input(buffer) == -1) {
        printf("\nInvalid input: %s\n", buffer);
      }

      buffer_index = 0;
      buffer[0] = '\0';
    }

    if (new_update) {
      printf("\n> %s", buffer);
      new_update = 0;
    }
  }
}

int process_input(char *buffer)
{
  char *token = strtok(buffer, " ");
  if (token == NULL) {
    return -1;
  }

  pid_t pid = str_to_pid(token);
  
  if (pid == -1) {
    printf("Invalid PID: %s\n", token);
    return -1;
  }

  token = strtok(NULL, " ");
  if (token == NULL) {
    return -1;
  }

  int signal = input_to_signal(token);

  if (signal == -1) {
    printf("Invalid signal: %s\n", token);
    return -1;
  }

  if (kill(pid, signal) == -1) {
    perror("kill");
    return -1;
  }

  return 0;
}
