#include "commands.h"
#include "ext2.h"
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char *argv[])
{
  if (argc != 2) {
    fprintf(stderr, "Usage: %s <image file>\n", argv[0]);
    return EXIT_FAILURE;
  }

  int fd = open(argv[1], O_RDONLY);

  if (fd == -1) {
    perror("open");
    return EXIT_FAILURE;
  }

  char command[256];
  char current_dir_path[256];

  while (1) {
    get_current_dir_path(fd, current_dir_path, sizeof(current_dir_path));

    printf("ext2shell|");
    printf("%s", current_dir_path);
    printf("> ");

    if (fgets(command, sizeof(command), stdin) == NULL) {
      break;
    }

    command[strcspn(command, "\n")] = 0;

    if (strcmp(command, "exit") == 0) {
      break;
    } else if (strcmp(command, "ls") == 0) {
      display_current_directory_entries(fd);
    } else {
      fprintf(stderr, "Unknown command: %s\n", command);
    }
    
  }

  close(fd);
  return EXIT_SUCCESS;
}