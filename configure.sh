TIME="America/Chicago"

# Hostname of the installed machine.
HOSTNAME='teddyheinen'

ln -sf "/usr/share/zoneinfo/${TIME}" /etc/localtime
hwclock --systohc

echo 'LANG="en_US.UTF-8"' >> /etc/locale.conf
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

echo $HOSTNAME > /etc/hostname

cat > /etc/hosts <<EOF
127.0.0.1 localhost.localdomain localhost ${HOSTNAME}
::1       localhost.localdomain localhost ${HOSTNAME}
EOF

pacman --noconfirm -S grub efibootmgr os-prober

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub

grub-mkconfig -o /boot/grub/grub.cfg

exit