#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ext2fs/ext2_fs.h>

#define DIR_PATH_LEN 256

FILE *img_fp;
struct ext2_super_block super_block;

struct ext2_dir_entry_2 current_dir_entry;
char current_dir_path[DIR_PATH_LEN];

int read_super_block();
int read_first_group_desc(struct ext2_group_desc *group_desc);
int read_inode_on_first_group(__u32 inode_num, struct ext2_inode *inode);
int read_dir_entry(struct ext2_inode *inode, struct ext2_dir_entry_2 *dir_entry);

void set_current_dir_entry_to_root();

void cd(char* dir);
void ls();
void stat(char* file);
void find(struct ext2_dir_entry_2 *dir_entry);
void sb();

int main(int argc, char **argv)
{
  char cmd[256];

  if (argc != 2) {
    fprintf(stderr, "Usage: %s <ext2 image file>\n", argv[0]);
    exit(1);
  }

  img_fp = fopen(argv[1], "r");

  if (img_fp == NULL) {
    perror("Failed to open image file");
    exit(1);
  }

  if (read_super_block() != 0) {
    exit(1);
  }

  set_current_dir_entry_to_root();

  while (1) {
    printf("%s> ", current_dir_path);
    fgets(cmd, 256, stdin);

    if (strncmp(cmd, "cd", 2) == 0) {
      cd(cmd + 3);
    } else if (strncmp(cmd, "ls", 2) == 0) {
      ls();
    } else if (strncmp(cmd, "stat", 4) == 0) {
      stat(cmd + 5);
    } else if (strncmp(cmd, "find", 4) == 0) {
      find(&current_dir_entry);
    } else if (strncmp(cmd, "sb", 2) == 0) {
      sb();
    } else if (strncmp(cmd, "exit", 4) == 0) {
      break;
    }
  }

  return 0;
}

int read_super_block()
{
  size_t read_size;

  fseek(img_fp, EXT2_MIN_BLOCK_SIZE, SEEK_SET);
  read_size = fread(&super_block, sizeof(struct ext2_super_block), 1, img_fp);

  if (read_size != 1) {
    fprintf(stderr, "Failed to read super block\n");
    return -1;
  }

  return 0;
}

int read_first_group_desc(struct ext2_group_desc *group_desc)
{
  size_t read_size;

  fseek(img_fp, EXT2_MIN_BLOCK_SIZE + sizeof(struct ext2_super_block), SEEK_SET);
  read_size = fread(group_desc, sizeof(struct ext2_group_desc), 1, img_fp);

  if (read_size != 1) {
    fprintf(stderr, "Failed to read first group descriptor\n");
    return -1;
  }

  return 0;
}

int read_inode_on_first_group(__u32 inode_num, struct ext2_inode *inode)
{
  struct ext2_group_desc group_desc;
  size_t read_size;

  if (read_first_group_desc(&group_desc) != 0) {
    return -1;
  }

  fseek(img_fp, group_desc.bg_inode_table * EXT2_MIN_BLOCK_SIZE + (inode_num - 1) * sizeof(struct ext2_inode), SEEK_SET);
  read_size = fread(inode, sizeof(struct ext2_inode), 1, img_fp);

  if (read_size != 1) {
    fprintf(stderr, "Failed to read inode %d\n", inode_num);
    return -1;
  }

  return 0;
}

int read_dir_entry(struct ext2_inode *inode, struct ext2_dir_entry_2 *dir_entry)
{
  size_t read_size;

  fseek(img_fp, inode->i_block[0] * EXT2_MIN_BLOCK_SIZE, SEEK_SET);
  read_size = fread(dir_entry, sizeof(struct ext2_dir_entry_2), 1, img_fp);

  if (read_size != 1) {
    perror("Failed to read directory entry");
    return -1;
  }

  return 0;
}

void set_current_dir_entry_to_root()
{
  struct ext2_group_desc group_desc;
  struct ext2_inode root_inode;

  if (read_first_group_desc(&group_desc) != 0) {
    exit(1);
  }

  if (read_inode_on_first_group(EXT2_ROOT_INO, &root_inode) != 0) {
    exit(1);
  }

  if (read_dir_entry(&root_inode, &current_dir_entry) != 0) {
    exit(1);
  }

  strncpy(current_dir_path, current_dir_entry.name, DIR_PATH_LEN);
}

void cd(char* dir)
{
  struct ext2_inode current_dir_inode;
  struct ext2_dir_entry_2 dir_entry;
  __u32 entry_offset;
  char temp_path[DIR_PATH_LEN + 1];

  if (strncmp(dir, "/", 1) == 0) {
    set_current_dir_entry_to_root();
    strncpy(current_dir_path, "/", DIR_PATH_LEN);
    return;
  }

  if (read_inode_on_first_group(current_dir_entry.inode, &current_dir_inode) != 0) {
    fprintf(stderr, "Failed to read current directory inode\n");
    return;
  }

  for (__u32 i = 0; i < current_dir_inode.i_blocks; i++) {
    entry_offset = 0;

    while (entry_offset < EXT2_MIN_BLOCK_SIZE) {
      fseek(img_fp, current_dir_inode.i_block[i] * EXT2_MIN_BLOCK_SIZE + entry_offset, SEEK_SET);
      fread(&dir_entry, sizeof(struct ext2_dir_entry_2), 1, img_fp);

      if (strncmp(dir, dir_entry.name, dir_entry.name_len) == 0) {
        goto found;
      }

      entry_offset += dir_entry.rec_len;
    }
  }

  fprintf(stderr, "Directory not found\n");
  return;

found:

  current_dir_entry = dir_entry;
  snprintf(temp_path, DIR_PATH_LEN + 1, "%s/%s", current_dir_path, dir);
  strncpy(current_dir_path, temp_path, DIR_PATH_LEN);
}

void ls()
{
  struct ext2_inode current_dir_inode;
  struct ext2_dir_entry_2 dir_entry;
  __u32 entry_offset;

  if (read_inode_on_first_group(current_dir_entry.inode, &current_dir_inode) != 0) {
    fprintf(stderr, "Failed to read current directory inode\n");
    return;
  }

  for (__u32 i = 0; i < current_dir_inode.i_blocks; i++) {
    entry_offset = 0;

    while (entry_offset < EXT2_MIN_BLOCK_SIZE) {
      fseek(img_fp, current_dir_inode.i_block[i] * EXT2_MIN_BLOCK_SIZE + entry_offset, SEEK_SET);
      fread(&dir_entry, sizeof(struct ext2_dir_entry_2), 1, img_fp);

      printf("%.*s\n", dir_entry.name_len, dir_entry.name);

      entry_offset += dir_entry.rec_len;
    }
  }
}

void stat(char* file)
{
  struct ext2_inode current_dir_inode;
  struct ext2_dir_entry_2 dir_entry;
  struct ext2_inode file_inode;
  __u32 entry_offset;

  if (read_inode_on_first_group(current_dir_entry.inode, &current_dir_inode) != 0) {
    fprintf(stderr, "Failed to read current directory inode\n");
    return;
  }

  for (__u32 i = 0; i < current_dir_inode.i_blocks; i++) {
    entry_offset = 0;

    while (entry_offset < EXT2_MIN_BLOCK_SIZE) {
      fseek(img_fp, current_dir_inode.i_block[i] * EXT2_MIN_BLOCK_SIZE + entry_offset, SEEK_SET);
      fread(&dir_entry, sizeof(struct ext2_dir_entry_2), 1, img_fp);

      if (strncmp(file, dir_entry.name, dir_entry.name_len) == 0) {

        if (read_inode_on_first_group(dir_entry.inode, &file_inode) != 0) {
          fprintf(stderr, "Failed to read file inode\n");
          return;
        }

        printf("File type: %d\n", file_inode.i_mode);
        printf("Inode: %d\n", dir_entry.inode);
        printf("Size: %d\n", file_inode.i_size);
        printf("Blocks: %d\n", file_inode.i_blocks);

        return;
      }

      entry_offset += dir_entry.rec_len;
    }
  }

  fprintf(stderr, "File not found\n");
}

void find(struct ext2_dir_entry_2 *dir_entry)
{
  struct ext2_inode current_dir_inode;
  struct ext2_dir_entry_2 temp_dir_entry;
  __u32 entry_offset;

  if (read_inode_on_first_group(dir_entry->inode, &current_dir_inode) != 0) {
    fprintf(stderr, "Failed to read current directory inode\n");
    return;
  }

  for (__u32 i = 0; i < current_dir_inode.i_blocks; i++) {
    entry_offset = 0;

    while (entry_offset < EXT2_MIN_BLOCK_SIZE) {
      fseek(img_fp, current_dir_inode.i_block[i] * EXT2_MIN_BLOCK_SIZE + entry_offset, SEEK_SET);
      fread(&temp_dir_entry, sizeof(struct ext2_dir_entry_2), 1, img_fp);

      if (strncmp(".", temp_dir_entry.name, temp_dir_entry.name_len) == 0) {
        continue;
      }

      if (strncmp("..", temp_dir_entry.name, temp_dir_entry.name_len) == 0) {
        continue;
      }

      if (temp_dir_entry.file_type == EXT2_FT_DIR) {
        printf("%.*s\n", temp_dir_entry.name_len, temp_dir_entry.name);
        find(&temp_dir_entry);
      }

      entry_offset += temp_dir_entry.rec_len;
    }
  }
}

void sb()
{
  printf("Inodes count: %d\n", super_block.s_inodes_count);
  printf("Blocks count: %d\n", super_block.s_blocks_count);
  printf("Free inodes count: %d\n", super_block.s_free_inodes_count);
  printf("Free blocks count: %d\n", super_block.s_free_blocks_count);
  printf("First data block: %d\n", super_block.s_first_data_block);
  printf("Block size: %d\n", EXT2_MIN_BLOCK_SIZE << super_block.s_log_block_size);
  printf("Blocks per group: %d\n", super_block.s_blocks_per_group);
  printf("Inodes per group: %d\n", super_block.s_inodes_per_group);
  printf("Magic: 0x%x\n", super_block.s_magic);
}
