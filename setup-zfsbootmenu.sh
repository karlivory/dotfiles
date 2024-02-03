#!/bin/bash

set -e

echo "##################################################################"
echo "## Install helpers"
apt update
apt install debootstrap gdisk zfsutils-linux

echo "##################################################################"
echo "## Set up vars, tmp files for debootstrap"
export CODENAME=lunar
export DISK=nvme0n1

mkdir -p /tmp/bootstrap/

cat <<EOF > /tmp/bootstrap/sources.list
# sources
deb http://ee.archive.ubuntu.com/ubuntu/ lunar main restricted
deb http://ee.archive.ubuntu.com/ubuntu/ lunar-updates main restricted
deb http://ee.archive.ubuntu.com/ubuntu/ lunar universe
deb http://ee.archive.ubuntu.com/ubuntu/ lunar-updates universe
deb http://ee.archive.ubuntu.com/ubuntu/ lunar multiverse
deb http://ee.archive.ubuntu.com/ubuntu/ lunar-updates multiverse
deb http://ee.archive.ubuntu.com/ubuntu/ lunar-backports main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu lunar-security main restricted
deb http://security.ubuntu.com/ubuntu lunar-security universe
deb http://security.ubuntu.com/ubuntu lunar-security multiverse
EOF

echo "##################################################################"
echo "## Source /etc/os-release"
source /etc/os-release
export ID="$ID"

echo "##################################################################"
echo "## Generate /etc/hostid"
zgenhostid -f 0x00bab10c

echo "##################################################################"
echo "## Define disk variables"
export BOOT_DISK="/dev/$DISK"
export BOOT_PART="1"
export BOOT_DEVICE="${BOOT_DISK}p${BOOT_PART}"
export POOL_DISK="/dev/$DISK"
export POOL_PART="2"
export POOL_DEVICE="${POOL_DISK}p${POOL_PART}"

cat <<EOF > /tmp/bootstrap/fstab
$(blkid | grep "$BOOT_DEVICE" | cut -d ' ' -f 2) /boot/efi vfat defaults 0 0
EOF

echo "------------------------------------------------------------------"
echo "Disk variables:"
echo "BOOT_DISK=$BOOT_DISK"
echo "BOOT_PART=$BOOT_PART"
echo "BOOT_DEVICE=$BOOT_DEVICE"
echo "POOL_DISK=$POOL_DISK"
echo "POOL_PART=$POOL_PART"
echo "POOL_DEVICE=$POOL_DEVICE"
echo "------------------------------------------------------------------"
read -rp "Looks good? (y/n)" choice
case "$choice" in 
  y|Y )        ;;
  n|N ) exit 1 ;;
    * ) exit 1 ;;
esac

echo "##################################################################"
echo "## Disk preparation"

echo "##################################################################"
echo "## Wipe partitions"
wipefs -a "$POOL_DISK"
wipefs -a "$BOOT_DISK"
sgdisk --zap-all "$POOL_DISK"
sgdisk --zap-all "$BOOT_DISK"

echo "##################################################################"
echo "## Create EFI boot partition"
sgdisk -n "${BOOT_PART}:1m:+512m" -t "${BOOT_PART}:ef00" "$BOOT_DISK"

echo "##################################################################"
echo "## Create zpool partition"
sgdisk -n "${POOL_PART}:0:-10m" -t "${POOL_PART}:bf00" "$POOL_DISK"

echo "##################################################################"
echo "## ZFS pool creation"

read -rp "Enter zroot pw: " ZROOT_PW
echo "$ZROOT_PW" > /etc/zfs/zroot.key
chmod 000 /etc/zfs/zroot.key

zpool create -f -o ashift=12 \
 -O compression=lz4 \
 -O acltype=posixacl \
 -O xattr=sa \
 -O relatime=on \
 -O encryption=aes-256-gcm \
 -O keylocation=file:///etc/zfs/zroot.key \
 -O keyformat=passphrase \
 -o autotrim=on \
 -m none zroot "$POOL_DEVICE"

echo "##################################################################"
echo "## Create initial file systems"
zfs create -o mountpoint=none zroot/ROOT
zfs create -o mountpoint=/ -o canmount=noauto zroot/ROOT/${ID}
zfs create -o mountpoint=/home zroot/home

zpool set bootfs=zroot/ROOT/${ID} zroot

echo "##################################################################"
echo "## Export, then re-import with a temporary mountpoint of /mnt"
zpool export zroot
zpool import -N -R /mnt zroot
zfs load-key -L prompt zroot

echo "##################################################################"
echo "## Verify that everything is mounted correctly"
mount | grep zroot

echo "##################################################################"
echo "## Update device symlinks"
udevadm trigger

echo "##################################################################"
echo "## Install Ubuntu"
debootstrap "$CODENAME" /mnt

echo "##################################################################"
echo "## Copy files into the new install"
cp /etc/hostid /mnt/etc/hostid
cp /etc/resolv.conf /mnt/etc/
mkdir /mnt/etc/zfs
cp /etc/zfs/zroot.key /mnt/etc/zfs
cp /tmp/bootstrap/sources.list /mnt/etc/apt/sources.list
cp /tmp/bootstrap/fstab /mnt/etc/fstab

echo "##################################################################"
echo "## Set up chroot mount points"
mount -t proc proc /mnt/proc
mount -t sysfs sys /mnt/sys
mount -B /dev /mnt/dev
mount -t devpts pts /mnt/dev/pts

echo "##################################################################"
echo "## (chroot) apt update && apt upgrade -y"
chroot /mnt /bin/bash -x <<-EOCHROOT
		DEBIAN_FRONTEND=noninteractive apt update && apt upgrade -y
	EOCHROOT

echo "##################################################################"
echo "## (chroot) Install additional base packages"
chroot /mnt /bin/bash -x <<-EOCHROOT
		apt install -y --no-install-recommends \
		  linux-generic locales keyboard-configuration console-setup \
		  curl network-manager
	EOCHROOT

echo "##################################################################"
echo "## (chroot) Reconfigure some stuff"
chroot /mnt /bin/bash -x <<-EOCHROOT
		locale-gen en_US.UTF-8 
		echo 'LANG="en_US.UTF-8"' > /etc/default/locale

		ln -fs /usr/share/zoneinfo/"Europe/Tallinn" /etc/localtime
		dpkg-reconfigure tzdata

	EOCHROOT

echo "##################################################################"
echo "## (chroot) Reconfigure some packages (interactive?)"
chroot /mnt /bin/bash -x <<-EOCHROOT
    dpkg-reconfigure keyboard-configuration console-setup
	EOCHROOT

echo "##################################################################"
echo "## (chroot) ZFS Configuration - Install required packages"
chroot /mnt /bin/bash -x <<-EOCHROOT
    apt -y install dosfstools zfs-initramfs zfsutils-linux
	EOCHROOT

echo "##################################################################"
echo "## (chroot) Enable systemd ZFS services"
chroot /mnt /bin/bash -x <<-EOCHROOT
    systemctl enable zfs.target
    systemctl enable zfs-import-cache
    systemctl enable zfs-mount
    systemctl enable zfs-import.target
	EOCHROOT

echo "##################################################################"
echo "## (chroot) Configure initramfs-tools"
chroot /mnt /bin/bash -x <<-EOCHROOT
    echo "UMASK=0077" > /etc/initramfs-tools/conf.d/umask.conf
	EOCHROOT

echo "##################################################################"
echo "## (chroot) Rebuild the initramfs"
chroot /mnt /bin/bash -x <<-EOCHROOT
    update-initramfs -c -k all
	EOCHROOT

echo "##################################################################"
echo "## (chroot) Set ZFSBootMenu properties on datasets"
chroot /mnt /bin/bash -x <<-EOCHROOT
    zfs set org.zfsbootmenu:commandline="quiet loglevel=4" zroot/ROOT
    zfs set org.zfsbootmenu:keysource="zroot/ROOT/${ID}" zroot
	EOCHROOT

echo "##################################################################"
echo "## (chroot) Create a vfat filesystem"
chroot /mnt /bin/bash -x <<-EOCHROOT
    mkfs.vfat -F32 "$BOOT_DEVICE"
	EOCHROOT

echo "##################################################################"
echo "## (chroot) Create an fstab entry and mount"
chroot /mnt /bin/bash -x <<-EOCHROOT
    mount /boot/efi
	EOCHROOT

echo "##################################################################"
echo "## (chroot) Install ZFSBootMenu"
chroot /mnt /bin/bash -x <<-EOCHROOT
    mkdir -p /boot/efi/EFI/ZBM
    curl -o /boot/efi/EFI/ZBM/VMLINUZ.EFI -L https://get.zfsbootmenu.org/efi
    cp /boot/efi/EFI/ZBM/VMLINUZ.EFI /boot/efi/EFI/ZBM/VMLINUZ-BACKUP.EFI
	EOCHROOT

echo "##################################################################"
echo "## (chroot) Configure EFI boot entries"
chroot /mnt /bin/bash -x <<-EOCHROOT
    mount -t efivarfs efivarfs /sys/firmware/efi/efivars
    apt install efibootmgr

    efibootmgr -c -d "$BOOT_DISK" -p "$BOOT_PART" \
      -L "ZFSBootMenu (Backup)" \
      -l \\EFI\\ZBM\\VMLINUZ-BACKUP.EFI

    efibootmgr -c -d "$BOOT_DISK" -p "$BOOT_PART" \
      -L "ZFSBootMenu" \
      -l \\EFI\\ZBM\\VMLINUZ.EFI
	EOCHROOT

echo "##################################################################"
echo "## Unmount, export the zpool"
umount -n -R /mnt
Export the zpool and reboot

echo "##################################################################"
echo "## Finished. Now reboot"
