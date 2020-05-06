#!/usr/bin/env bash
# print cmd before exec it and exit when cmd exec fail.
set -xe

timedatectl set-ntp true

# default assume we have GPT partition with 
# root partition in /dev/sda1
# efi partition in /dev/sda2
mkfs.ext4 /dev/sda1
mkfs.vfat /dev/sda2
mkdir -p /mnt/boot/efi
# mount /
mount /dev/sda1 /mnt
mount /dev/sda2 /mnt/boot/efi

# set mirrors of china
cat << 'EOF' > /etc/pacman.d/mirrorlist
Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.neusoft.edu.cn/archlinux/$repo/os/$arch
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
Server = http://mirror.lzu.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.163.com/archlinux/$repo/os/$arch
Server = http://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
Server = http://mirrors.neusoft.edu.cn/archlinux/$repo/os/$arch
EOF

mkdir -p /mnt/root
cp archlinux_post.sh /mnt/root/archlinux_post.sh

pacstrap /mnt base linux linux-firmware && \
	genfstab -U /mnt >> /mnt/etc/fstab && \
	chmod +x /mnt/root/archlinux_post.sh && \
	arch-chroot /mnt /root/archlinux_post.sh && \
	reboot
