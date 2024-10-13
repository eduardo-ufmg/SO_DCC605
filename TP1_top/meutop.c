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

int main()
{
  pthread_t monitor_thread;
  pthread_t control_thread;

  if (pthread_create(&monitor_thread, NULL, (void *)monitor_processes, (void *)PRINT_PROCESSES_TIME) != 0) {
    perror("pthread_create");
    return -1;
  }

  if (pthread_create(&control_thread, NULL, (void *)control_signals, NULL) != 0) {
    perror("pthread_create");
    return -1;
  }

  pthread_join(monitor_thread, NULL);
  pthread_join(control_thread, NULL);

  return 0;
}
