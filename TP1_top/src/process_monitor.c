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

int print_processes(const int n)
{
  DIR *dir;
  struct dirent *entry;
  pid_t pid;
  char ownername[MAX_OWNERNAME_BUFFER_SIZE];
  char name[MAX_PROCNAME_BUFFER_SIZE];
  char state[MAX_STATE_BUFFER_SIZE];
  int count = 0;

  if ((dir = opendir("/proc")) == NULL) {
    perror("opendir");
    return -1;
  }

  print_header();

  while ((entry = readdir(dir)) != NULL) {
    if (is_directory("/proc", entry)) {
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

int is_directory(const char *path, const struct dirent *entry)
{
  struct stat statbuf;
  char fullpath[MAX_PATH_BUFFER_SIZE];

  snprintf(fullpath, MAX_PATH_BUFFER_SIZE, "%s/%s", path, entry->d_name);

  if (stat(fullpath, &statbuf) == -1) {
    perror("stat");
    return 0;
  }

  return S_ISDIR(statbuf.st_mode);
}

int is_file(const char *path, const struct dirent *entry)
{
  struct stat statbuf;
  char fullpath[MAX_PATH_BUFFER_SIZE];

  snprintf(fullpath, MAX_PATH_BUFFER_SIZE, "%s/%s", path, entry->d_name);

  if (stat(fullpath, &statbuf) == -1) {
    perror("stat");
    return 0;
  }

  return S_ISREG(statbuf.st_mode);
}

int get_username_by_uid(const uid_t uid, char *username, const size_t size)
{
  struct passwd *pwd;

  if ((pwd = getpwuid(uid)) == NULL) {
    perror("getpwuid");
    return -1;
  }

  strncpy(username, pwd->pw_name, size);
  return 0;
}

int get_ownername(const pid_t pid, char *ownername, const size_t size)
{
  char path[MAX_PATH_BUFFER_SIZE];
  FILE *file;

  snprintf(path, MAX_PATH_BUFFER_SIZE, "/proc/%d/status", pid);

  if ((file = fopen(path, "r")) == NULL) {
    perror("fopen");
    return -1;
  }

  while (fgets(path, MAX_PATH_BUFFER_SIZE, file) != NULL) {
    if (strncmp(path, "Uid:", 4) == 0) {
      fclose(file);
      return get_username_by_uid(atoi(path + 5), ownername, size);
    }
  }

  fclose(file);
  return -1;
}

int get_process_state(const pid_t pid, char *state, const size_t size)
{
  char path[MAX_PATH_BUFFER_SIZE];
  FILE *file;

  snprintf(path, MAX_PATH_BUFFER_SIZE, "/proc/%d/status", pid);

  if ((file = fopen(path, "r")) == NULL) {
    perror("fopen");
    return -1;
  }

  while (fgets(path, MAX_PATH_BUFFER_SIZE, file) != NULL) {
    if (strncmp(path, "State:", 6) == 0) {
      strncpy(state, path + 7, size);
      fclose(file);
      return 0;
    }
  }

  fclose(file);
  return -1;
}

int get_process_name_without_path(const pid_t pid, char *name, const size_t size)
{
  char path[MAX_PATH_BUFFER_SIZE];
  FILE *file;

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

  char *last_slash = strrchr(name, '/');
  if (last_slash != NULL) {
    *last_slash = '\0';
    char *second_to_last_slash = strrchr(name, '/');
    *last_slash = '/';

    if (second_to_last_slash != NULL) {
      strcpy(name, second_to_last_slash + 1);
    }
  }

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
