#include "ext2.h"
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

void get_current_dir_path(int fd, char *path, size_t size)
{
    // Initialize the path as an empty string
    path[0] = '\0';

    // Read the superblock
    struct ext2_super_block super_block;
    lseek(fd, 1024, SEEK_SET);
    read(fd, &super_block, sizeof(super_block));

    // Read the group descriptor
    struct ext2_group_desc group_desc;
    lseek(fd, 2048, SEEK_SET);
    read(fd, &group_desc, sizeof(group_desc));

    // Read the root inode
    struct ext2_inode root_inode;
    lseek(fd, group_desc.bg_inode_table * EXT2_BLOCK_SIZE + sizeof(struct ext2_inode), SEEK_SET);
    read(fd, &root_inode, sizeof(root_inode));

    // Traverse the directory entries to construct the path
    struct ext2_dir_entry dir_entry;
    size_t offset = 0;
    while (offset < root_inode.i_size) {
        lseek(fd, root_inode.i_block[0] * EXT2_BLOCK_SIZE + offset, SEEK_SET);
        read(fd, &dir_entry, sizeof(dir_entry));

        if (dir_entry.inode != 0) {
            strncat(path, "/", size - strlen(path) - 1);
            strncat(path, dir_entry.name, size - strlen(path) - 1);
        }

        offset += dir_entry.rec_len;
    }
}
