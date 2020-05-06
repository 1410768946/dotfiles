#!/usr/bin/env bash
set -xe

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock -systohc --utc

# locale
sed -i 's/#zh_CN.UTF-8/zh_CN.UTF-8/g' /etc/locale.gen
sed -i 's/#en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf

echo curtain > /etc/hostname
cat << EOF >> /etc/hosts
127.0.0.1	localhost
127.0.0.1	curtain
EOF

# archlinuxcn source
cat << EOF >> /etc/pacman.conf
[archlinuxcn]
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
EOF
# upgrade system
pacman -Syyu --noconfirm
pacman -S vim git grub efibootmgr networkmanager openssh --noconfirm
grub-install --target=x86_64-efi --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

# self enable networkmanager
systemctl enable NetworkManager
systemctl enable sshd

echo "set root passwd"
passwd
