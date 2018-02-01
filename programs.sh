cat packages.txt | while read line
do
	pacman --noconfirm -S $line
done

wget https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=aura-bin -O "PKGBUILD"
makepkg -si