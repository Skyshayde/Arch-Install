
# Drive to install to.
DRIVE='/dev/sda'


make_partitions() {
	sgdisk -n 1::+550M -t 1:EF00 -g $DRIVE
	mkfs.fat -F32 "${DRIVE}1"

	sgdisk -n 2::$ENDSECTOR -g $DRIVE
	mkfs.ext4 "${DRIVE}2"
	mount /dev/sda2 /mnt
	mkdir /mnt/boot
	mount /dev/sda1 /mnt/boot
}


preinstall_check() {
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
	wget http://arch.teddyheinen.com/configure.sh -O configure.sh
	# arch-chroot /mnt ./configure.sh
}
preinstall_check
make_partitions

install_arch
