import os
import subprocess

# Define the image file name and size
img_file = 'fs-0x00dcc605-ext2-10240.img'
img_size = '10M'  # 10 Megabytes

# Define the directories and files to be created
directories = ['dir1', 'dir2', 'dir3']
files = {
  'dir1/file1.txt': 'Content of file1 in dir1',
  'dir2/file2.txt': 'Content of file2 in dir2',
  'dir3/file3.txt': 'Content of file3 in dir3'
}

# Create the image file if it doesn't exist
if not os.path.exists(img_file):
  subprocess.run(['dd', 'if=/dev/zero', f'of={img_file}', f'bs={img_size}', 'count=1'])
  subprocess.run(['mkfs.ext2', img_file])

# Mount the image file
mount_point = 'mnt_point'
os.makedirs(mount_point, exist_ok=True)
subprocess.run(['sudo', 'mount', '-o', 'loop', img_file, mount_point])

# Create directories and files in the mounted image
for directory in directories:
  os.makedirs(os.path.join(mount_point, directory), exist_ok=True)

for file_path, content in files.items():
  full_path = os.path.join(mount_point, file_path)
  with open(full_path, 'w') as f:
    f.write(content)

# Unmount the image file
subprocess.run(['sudo', 'umount', mount_point])
os.rmdir(mount_point)

print(f"{img_file} created and populated successfully.")