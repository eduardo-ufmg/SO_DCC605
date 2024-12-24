CC = gcc
CFLAGS = -Wall -Wextra -Werror -pedantic -Iinclude

SRC = src/main.c src/commands.c src/ext2.c
OBJ_DIR = obj
OBJ = $(SRC:src/%.c=$(OBJ_DIR)/%.o)
TARGET = dcc_fs_shell

all: $(TARGET)

$(OBJ_DIR)/%.o: src/%.c
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm -f $(OBJ) $(TARGET)