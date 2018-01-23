
# Drive to install to.
DRIVE='/dev/sda'

TIME="America/Chicago"

# Hostname of the installed machine.
HOSTNAME='teddyheinen'

make_partitions() {
	sgdisk -n 1::+550M -t 1:EF00 -g $DRIVE
	mkfs.fat -F32 "${DRIVE}1"
	mkdir /mnt/boot

	sgdisk -n 2::$ENDSECTOR -g $DRIVE
	mkfs.ext4 "${DRIVE}2"
}
mount_partitions() {
	mount /dev/sda2 /mnt
	mount /dev/sda1 /mnt/boot
}

check_preinstall() {
	if ! pushd /sys/firmware/efi/efivars;then
		exit 1
	fi
	if ! ping -c 1 archlinux.org &> /dev/null;then
		exit 1
	fi
}

install_arch() {
	timedatectl set-ntp true
	pacstrap /mnt base
	genfstab -U /mnt >> /mnt/etc/fstab
	wget https://raw.githubusercontent.com/Skyshayde/Arch-Install/master/configure.sh configure.sh
	arch-chroot /mnt ./configure.sh
}
check_preinstall
make_partitions
mount_partitions
install_arch
