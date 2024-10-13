#ifndef TOP_H
#define TOP_H

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

#define MAX_PROCESSES_TO_PRINT 20
#define PRINT_PROCESSES_TIME 1
#define MAX_PATH_BUFFER_SIZE 512
#define MAX_COMMAND_BUFFER_SIZE 512
#define MAX_OWNERNAME_BUFFER_SIZE 64
#define MAX_STATE_BUFFER_SIZE 16
#define MAX_NAME_BUFFER_SIZE 256
#define MAX_PID_BUFFER_SIZE 16
#define MAX_SIGNAL_BUFFER_SIZE 16

/*
  function to print the first n processes found
  receives: n - number of processes to print
  returns: success or failure
*/
int print_processes(const int n);

/*
  function to call print_processes each time_s seconds (a thread)
  receives: time_s - time in seconds
  returns: void
*/
void monitor_processes(const int time_s);

/*
  function to convert string to process id
  receives: str - string to convert
  returns: process id or -1 if error
*/
pid_t str_to_pid(const char *str);

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

/*
  function to read input, convert it and send signal (a thread)
  receives: void
  returns: void
*/
void control_signals();

/*
  function to check if a path is a directory
  receives: path - path to check
            entry - entry to check
  returns: 1 if true, 0 if false
*/
int is_directory(const char *path, const struct dirent *entry);

/*
  function to check if a path is a file
  receives: path - path to check
            entry - entry to check
  returns: 1 if true, 0 if false
*/
int is_file(const char *path, const struct dirent *entry);

/*
  function to get the username of a uid
  receives: uid - user id
            username - buffer to store the username
            size - size of the buffer
  returns: success or failure
*/
int get_username_by_uid(const uid_t uid, char *username, const size_t size);

/*
  function to get the username of a process owner
  receives: pid - process id
            ownername - buffer to store the username
            size - size of the buffer
  returns: success or failure
*/
int get_ownername(const pid_t pid, char *ownername, const size_t size);

/*
  function to get the state of a process
  receives: pid - process id
            state - buffer to store the state
            size - size of the buffer
  returns: success or failure
*/
int get_process_state(const pid_t pid, char *state, const size_t size);

/*
  function to get the name of a process
  receives: pid - process id
            name - buffer to store the name
            size - size of the buffer
  returns: success or failure
*/
int get_process_name_without_path(const pid_t pid, char *name, const size_t size);

/*
  function to print the header of the process table
  receives: void
  returns: void
*/
void print_header();

/*
  function to print a single process information
  receives: pid - process id
            username - username of the process owner
            command - command name of the process
            state - state of the process
  returns: void
*/
void print_process_info(const pid_t pid, const char *username, const char *command, const char *state);

#endif // TOP_H
