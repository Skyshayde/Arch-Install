
# Drive to install to.
DRIVE='/dev/sda'

TIME="America/Chicago"

# Hostname of the installed machine.
HOSTNAME='teddyheinen'

make_partitions() {
	sgdisk -n 1::+550M -t 1:EF00 -g $DRIVE
	mkfs.fat -F32 "${DRIVE}1"
	mkdir /mnt/boot

	sgdisk -n 1::$ENDSECTOR -g $DRIVE
	mkfs.ext4 "${DRIVE}2"
}
mount_partitions() {
	mount /dev/sda2 /mnt
	mount /dev/sda1 /mnt/boot
}

configure() {
	timedatectl set-ntp true
	pacstrap /mnt base
	genfstab -U /mnt >> /mnt/etc/fstab
	arch-chroot /mnt


	ln -sf "/usr/share/zoneinfo/${TIME}" /etc/localtime
	hwclock --systohc

    echo 'LANG="en_US.UTF-8"' >> /etc/locale.conf
    echo 'LC_COLLATE="C"' >> /etc/locale.conf
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen

    echo "$hostname" > /etc/hostname

    cat > /etc/hosts <<EOF
127.0.0.1 localhost.localdomain localhost $hostname
::1       localhost.localdomain localhost $hostname
EOF
	
	pacman --noconfirm -S grub efibootmgr

	grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
	grub-mkconfig -o /boot/grub/grub.cfg
	exit
}
check_preinstall() {
	if ! pushd /sys/firmware/efi/efivars;then
		exit 1
	fi
	if ! ping -c 1 archlinux.org &> /dev/null;then
		exit 1
	fi
}

check_preinstall
make_partitions
mount_partitions
configure
