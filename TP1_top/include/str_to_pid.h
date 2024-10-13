#ifndef STR_TO_PID_H
#define STR_TO_PID_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>

/*
  function to convert string to process id
  receives: str - string to convert
  returns: process id or -1 if error
*/
pid_t str_to_pid(const char *str);

#endif // STR_TO_PID_H
