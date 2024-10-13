#ifndef PROCESS_MONITOR_H
#define PROCESS_MONITOR_H

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
#define MAX_PROCNAME_BUFFER_SIZE 64
#define MAX_OWNERNAME_BUFFER_SIZE 64
#define MAX_STATE_BUFFER_SIZE 64

typedef struct {
  int time_s;
  int n;
} monitor_processes_args;

/*
  function to print the first n processes found
  receives: n - number of processes to print
  returns: success or failure
*/
int print_processes(const int n);

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

#endif // PROCESS_MONITOR_H
