#include "top.h"

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

int print_processes(const int n)
{
  DIR *dir;
  struct dirent *entry;
  char username[MAX_PATH_BUFFER_SIZE];
  char state[MAX_PATH_BUFFER_SIZE];
  char command[MAX_COMMAND_BUFFER_SIZE];
  pid_t pid;
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
        if (get_ownername(pid, username, MAX_PATH_BUFFER_SIZE) == -1) {
          continue;
        }
        if (get_process_state(pid, state, MAX_PATH_BUFFER_SIZE) == -1) {
          continue;
        }
        if (get_process_name_without_path(pid, command, MAX_NAME_BUFFER_SIZE) == -1) {
          continue;
        }
        print_process_info(pid, username, command, state);
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

void monitor_processes(const int time_s)
{
  while (1) {
    system("clear");
    print_processes(MAX_PROCESSES_TO_PRINT);
    sleep(time_s);
  }
}

pid_t str_to_pid(const char *str)
{
  char *endptr;

  pid_t pid = strtol(str, &endptr, 10);

  if (endptr == str || *endptr != '\0') {
    return -1;
  }

  return pid;
}

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

int str_int_to_signal(const char *str)
{
  char *endptr;

  int sig = strtol(str, &endptr, 10);

  if (endptr == str || *endptr != '\0') {
    return -1;
  }

  return sig;
}

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

int send_signal(const pid_t pid, const int sig)
{
  if (kill(pid, sig) == -1) {
    perror("kill");
    return -1;
  }

  return 0;
}

void control_signals()
{
  char input[MAX_PATH_BUFFER_SIZE];
  char *token;
  pid_t pid;
  int sig;

  while (1) {
    fgets(input, MAX_PATH_BUFFER_SIZE, stdin);
    token = strtok(input, " ");

    if (token == NULL) {
      continue;
    }

    pid = str_to_pid(token);
    if (pid == -1) {
      continue;
    }

    token = strtok(NULL, " ");
    if (token == NULL) {
      continue;
    }

    sig = input_to_signal(token);
    if (sig == -1) {
      continue;
    }

    send_signal(pid, sig);
  }
}

int input_to_signal(const char *input)
{
  int sig;

  sig = str_signal_to_signal(input);
  if (sig == -1) {
    sig = str_int_to_signal(input);
  }

  return sig;
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
    char *first_space = strchr(last_slash + 1, ' ');
    if (first_space != NULL) {
      *first_space = '\0';
    }
    memmove(name, last_slash + 1, strlen(last_slash));
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
