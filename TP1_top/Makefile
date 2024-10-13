# Compiler
CC = gcc

# Compiler flags
CFLAGS = -D_POSIX_C_SOURCE -Wall -Wextra -std=c11 -Iinclude

# Source files
SRCS = $(wildcard src/*.c) meutop.c

# Object files
OBJS = $(SRCS:.c=.o)

# Executable name
TARGET = meutop

# Default target
all: $(TARGET)

# Link object files to create the executable
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ -lpthread
	$(MAKE) clean

# Compile source files to object files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Clean up build files
clean:
	rm -f $(OBJS)

# Phony targets
.PHONY: all clean