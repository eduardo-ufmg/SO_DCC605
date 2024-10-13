#include "str_to_pid.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>

pid_t str_to_pid(const char *str)
{
  char *endptr;

  pid_t pid = strtol(str, &endptr, 10);

  if (endptr == str || *endptr != '\0') {
    return -1;
  }

  return pid;
}
