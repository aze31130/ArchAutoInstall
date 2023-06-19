#!/bin/bash
set -e

#############
username="aze"
password="aze"
root_password="root"
test_server="1.1.1.1"
ultra_minimalist=1
#############

echo "Welcome to this auto-install script."

# Step 1: Test for internet connexion
if ! ping -c 1 $test_server 1>/dev/null; then
    echo "It seems that your computer is not connected to the internet, please try again with a working network configuration !" >&2
    exit 1
fi

# 2 uses cfdisk to create partition

# 3 mkfs on /dev/sda1

# 4 mount /dev/sda1 on /mnt

# 5 configure pacman (update keyring, parallel download, ILoveCandy)

# 6 Download essentials packages (base, linux)

# 7 Generate fstab

# 8 Chroot into /mnt

# 9 Install bootloader

# 10 Reboot