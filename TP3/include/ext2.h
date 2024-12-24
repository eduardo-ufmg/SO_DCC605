#ifndef EXT2_H
#define EXT2_H

#include <stdint.h>
#include <stdlib.h>

#define EXT2_BLOCK_SIZE 1024

typedef uint32_t __le32;
typedef uint16_t __le16;

struct ext2_super_block {
  __le32 s_inodes_count;
  __le32 s_blocks_count;
  __le32 s_r_blocks_count;
  __le32 s_free_blocks_count;
  __le32 s_free_inodes_count;
  __le32 s_first_data_block;
  __le32 s_log_block_size;
  __le32 s_blocks_per_group;
  __le32 s_inodes_per_group;
  __le16 s_magic;
  __le32 s_first_ino;
  __le16 s_inode_size;
};

struct ext2_group_desc {
  __le32 bg_block_bitmap;
  __le32 bg_inode_bitmap;
  __le32 bg_inode_table;
  __le16 bg_free_blocks_count;
  __le16 bg_free_inodes_count;
  __le16 bg_used_dirs_count;
  __le16 bg_pad;
  __le32 bg_reserved[3];
};

struct ext2_inode {
  __le16 i_mode;
  __le16 i_uid;
  __le32 i_size;
  __le32 i_atime;
  __le32 i_ctime;
  __le32 i_mtime;
  __le32 i_dtime;
  __le16 i_gid;
  __le16 i_links_count;
  __le32 i_blocks;
  __le32 i_flags;
  __le32 i_block[15];
};

struct ext2_dir_entry {
  __le32 inode;
  __le16 rec_len;
  __le16 name_len;
  char name[];
};

void get_current_dir_path(int fd, char *path, size_t size);

#endif // EXT2_H
