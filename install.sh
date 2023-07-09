#!/bin/bash
set -e

#############
username="aze"
password="aze"
root_password="root"
test_server="1.1.1.1"
disk_device="/dev/sda"
ultra_minimalist=1
#############

echo "Welcome to this auto-install script."

# Step 1: Test for internet connexion
if ! ping -c 1 $test_server 1>/dev/null; then
    echo "It seems that your computer is not connected to the internet, please try again with a working network configuration !" >&2
    exit 1
fi

# Step 2: Create 3 partitions (Swap, Bootloader, Filesystem)
parted -s $disk_device mklabel gpt mkpart primary linux-swap 1MiB 4GiB mkpart primary fat32 4GiB 4.5GiB mkpart primary ext4 4.5GiB 100%

# At this point, the disk will look like that:
# /dev/sda1 (4G Swap partition)
# /dev/sda2 (512M Bootloader partition)
# /dev/sda3 (All the remaining root filesystem parition)

# Step 3: Create file systems
mkswap /dev/sda1
mkfs.fat /dev/sda2
mkfs.ext4 /dev/sda3

# Step 4: Mount root filesystem into on /mnt
swapon /dev/sda1
mount /dev/sda2 /boot
mount /dev/sda3 /mnt

# Step 5: configure pacman (update keyring, parallel download, ILoveCandy)
# Enable parallel download
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
pacstrap /mnt base linux

# Step 6: Generate fstab
genfstab /mnt>/mnt/etc/fstab

# Step 7: Chroot into /mnt and install bootloader
arch-chroot /mnt bash -c 'pacman -Sy grub;grub-install /dev/sda;grub-mkconfig -o /boot/grub/grub.cfg'

# Step 8 Download essentials packages

# Step 9 Reboot