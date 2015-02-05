#!/bin/bash
#WARNING: This reformats a drive! (DATALOSS!)
# Recreates /boot/efi (reformates drive, reinstalls grub, recreates dependency db and updates fstab)
#Needs to be executed as root.
#

#Set this to the device you want to use as /boot/efi
device="/dev/sda1"

#End config

echo "Going to recreate boot/EFI, assuming /boot/efi is $device"

echo "type YES to fuck over $device."
echo "WARNING: This reformats a drive! (DATALOSS!)"
read answer

if [ "$answer" != "YES" ]; then
	echo "You fucked up on fucking up $device";
	exit;
fi

echo "Bye Bye $device"

mkfs.vfat -F 32 /dev/sda1
blkid  -s UUID -o value /dev/sda1 | xargs -I{} sed -i 's_^UUID=\S*\s*/boot/efi\s_UUID={} /boot/efi _' /etc/fstab
mount /dev/sda1 /boot/efi
grub-install --uefi-secure-boot
depmod
umount /boot/efi

echo ""