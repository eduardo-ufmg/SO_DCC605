CC = gcc
CFLAGS = -Wall -Wextra -Werror -pedantic
TARGET = dcc_fs_shell
DEBUG ?= 0

ifeq ($(DEBUG), 1)
	CFLAGS += -DDEBUG
endif

all: $(TARGET)

$(TARGET): dcc_fs_shell.o
	$(CC) $(CFLAGS) -o $(TARGET) dcc_fs_shell.o -lext2fs

dcc_fs_shell.o: dcc_fs_shell.c
	$(CC) $(CFLAGS) -c dcc_fs_shell.c

clean:
	rm -f $(TARGET) dcc_fs_shell.o

.PHONY: all clean