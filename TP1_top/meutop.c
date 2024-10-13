#include "top.h"

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define MAX_PROCESSES_TO_PRINT 64
#define PRINT_PROCESSES_TIME 1

int main()
{
  pthread_t monitor_thread;
  pthread_t control_thread;
  monitor_processes_args args = {PRINT_PROCESSES_TIME, MAX_PROCESSES_TO_PRINT};

  if (pthread_create(&monitor_thread, NULL, (void *)monitor_processes, &args) != 0) {
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
