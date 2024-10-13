#include "process_monitor.h"

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
  function to print the first n processes found
  receives: n - number of processes to print
  returns: success or failure
*/
int print_processes(const int n)
{
  /*
    DIR: structure representing a directory
    dirent: structure representing a directory entry
    pid_t: process ID type
  */
  DIR *dir;
  struct dirent *entry;
  pid_t pid;
  char ownername[MAX_OWNERNAME_BUFFER_SIZE];
  char name[MAX_PROCNAME_BUFFER_SIZE];
  char state[MAX_STATE_BUFFER_SIZE];
  int count = 0;

  // processes are stored in /proc
  if ((dir = opendir("/proc")) == NULL) {
    perror("opendir");
    return -1;
  }

  print_header();

  /*
    readdir: reads the next directory entry
             it keeps track of the current position in the directory
             and returns NULL when there are no more entries
  */
  while ((entry = readdir(dir)) != NULL) {
    if (is_directory("/proc", entry)) {
      // the name of the directory that holds the process information is its PID
      pid = str_to_pid(entry->d_name);

      if (pid != -1) {
        if (get_ownername(pid, ownername, MAX_OWNERNAME_BUFFER_SIZE) == -1) {
          continue;
        }
        if (get_process_state(pid, state, MAX_STATE_BUFFER_SIZE) == -1) {
          continue;
        }
        if (get_process_name_without_path(pid, name, MAX_PROCNAME_BUFFER_SIZE) == -1) {
          continue;
        }
        print_process_info(pid, ownername, name, state);
        count++;
      }
    }

    if (count == n) {
      break;
    }
  }

  closedir(dir);
  return 0;
}

/*
  function to check if a path is a directory
  receives: path - path to check
            entry - entry to check
  returns: 1 if true, 0 if false
*/
int is_directory(const char *path, const struct dirent *entry)
{
  /*
    stat: structure that contains information about a entry in the file system
  */
  struct stat statbuf;
  char fullpath[MAX_PATH_BUFFER_SIZE];

  // create the full path to the entry
  snprintf(fullpath, MAX_PATH_BUFFER_SIZE, "%s/%s", path, entry->d_name);

  /*
    stat: get entry status
          fills a stat structure with information about the entry pointed to by path
          returns -1 if an error occurs
  */
  if (stat(fullpath, &statbuf) == -1) {
    perror("stat");
    return 0;
  }

  /*
    S_ISDIR: macro to check if the file is a directory
             defined in sys/stat.h
    st_mode: file mode
             if it's a directory, the S_IFDIR bit is set
  */
  return S_ISDIR(statbuf.st_mode);
}

/*
  function to check if a path is a file
  receives: path - path to check
            entry - entry to check
  returns: 1 if true, 0 if false
*/
int is_file(const char *path, const struct dirent *entry)
{
  /*
    stat: structure that contains information about a entry in the file system
  */
  struct stat statbuf;
  char fullpath[MAX_PATH_BUFFER_SIZE];

  // create the full path to the entry
  snprintf(fullpath, MAX_PATH_BUFFER_SIZE, "%s/%s", path, entry->d_name);

  /*
    stat: get entry status
          fills a stat structure with information about the entry pointed to by path
          returns -1 if an error occurs
  */
  if (stat(fullpath, &statbuf) == -1) {
    perror("stat");
    return 0;
  }

  /*
    S_ISREG: macro to check if the file is a regular file
             defined in sys/stat.h
    st_mode: file mode
             if it's a regular file, the S_IFREG bit is set
  */
  return S_ISREG(statbuf.st_mode);
}

/*
  function to get the username of a uid
  receives: uid - user id
            username - buffer to store the username
            size - size of the buffer
  returns: success or failure
*/
int get_username_by_uid(const uid_t uid, char *username, const size_t size)
{
  /*
    passwd: structure that contains information about a user
            weird name
  */
  struct passwd *pwd;

  /*
    getpwuid: get user information by user id
              returns a pointer to a passwd structure
              returns NULL if an error occurs
  */
  if ((pwd = getpwuid(uid)) == NULL) {
    perror("getpwuid");
    return -1;
  }

  /*
    strncpy: copy a string
             destination, source, size
  */
  strncpy(username, pwd->pw_name, size);
  return 0;
}

/*
  function to get the owner name of a process
  receives: pid - process id
            ownername - buffer to store the owner name
            size - size of the buffer
  returns: success or failure
*/
int get_ownername(const pid_t pid, char *ownername, const size_t size)
{
  char path[MAX_PATH_BUFFER_SIZE];
  FILE *file;

  // create the path to the status file of the process
  snprintf(path, MAX_PATH_BUFFER_SIZE, "/proc/%d/status", pid);

  if ((file = fopen(path, "r")) == NULL) {
    perror("fopen");
    return -1;
  }

  /*
    fgets: read the next line from a file
           internally stores the position it is when it returns
           returns NULL when it reaches the end of the file
  */
  while (fgets(path, MAX_PATH_BUFFER_SIZE, file) != NULL) {
    const char *owner_field = "Uid:";
    const size_t owner_field_len = strlen(owner_field);
    /*
      strncmp: compare the first n characters of two strings
               returns 0 if they are equal
    */
    if (strncmp(path, owner_field, owner_field_len) == 0) {
      fclose(file);
      // passes the start of the string right after the owner field key
      // which is the owner id
      return get_username_by_uid(atoi(path + owner_field_len + 1), ownername, size);
    }
  }

  fclose(file);
  return -1;
}

/*
  function to get the state of a process
  receives: pid - process id
            state - buffer to store the state
            size - size of the buffer
  returns: success or failure
*/
int get_process_state(const pid_t pid, char *state, const size_t size)
{
  char path[MAX_PATH_BUFFER_SIZE];
  FILE *file;

  // create the path to the status file of the process
  snprintf(path, MAX_PATH_BUFFER_SIZE, "/proc/%d/status", pid);

  if ((file = fopen(path, "r")) == NULL) {
    perror("fopen");
    return -1;
  }

  /*
    fgets: read the next line from a file
           internally stores the position it is when it returns
           returns NULL when it reaches the end of the file
  */
  while (fgets(path, MAX_PATH_BUFFER_SIZE, file) != NULL) {
    const char *state_field = "State:";
    const size_t state_field_len = strlen(state_field);
    /*
      strncmp: compare the first n characters of two strings
               returns 0 if they are equal
    */
    if (strncmp(path, state_field, state_field_len) == 0) {
      /*
        strncpy: copy a string
                 destination, source, size
        source is the start of the string right after the state field key
        which is the state of the process
      */
      strncpy(state, path + state_field_len + 1, size);
      fclose(file);
      return 0;
    }
  }

  fclose(file);
  return -1;
}

/*
  function to get the name of a process
  receives: pid - process id
            name - buffer to store the name
            size - size of the buffer
  returns: success or failure
*/
int get_process_name_without_path(const pid_t pid, char *name, const size_t size)
{
  char path[MAX_PATH_BUFFER_SIZE];
  FILE *file;

  // create the path to the command line file of the process
  snprintf(path, MAX_PATH_BUFFER_SIZE, "/proc/%d/cmdline", pid);

  if ((file = fopen(path, "r")) == NULL) {
    perror("fopen");
    return -1;
  }

  if (fgets(name, size, file) == NULL) {
    fclose(file);
    return -1;
  }

  fclose(file);

  /*
    strrchr: find the last occurrence of a character in a string
             returns a pointer to the character
             returns NULL if the character is not found
    strcpy: recude name to the last part of the path
  */
  char *last_slash = strrchr(name, '/');
  if (last_slash != NULL) {
    strcpy(name, last_slash + 1);
  }

  /*
    strchr: find the first occurrence of a character in a string
            returns a pointer to the character
            returns NULL if the character is not found
    replace the first space with a null terminator
    so only the name is printed
  */
  char *first_space = strchr(name, ' ');
  if (first_space != NULL) {
    *first_space = '\0';
  }

  return 0;
}

void print_header()
{
  printf("%-10s %-20s %-20s %-20s\n", "PID", "OWNER", "NAME", "STATE");
}

void print_process_info(const pid_t pid, const char *username, const char *command, const char *state)
{
  printf("%-10d %-20s %-20s %-20s\n", pid, username, command, state);
}
