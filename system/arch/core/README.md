## Introduction

My notes of Arch Linux installation.

- Boot with `systemd-boot` via UEFI.

- GPT partition table with two partitions: boot and LUKS encrypted
  system.

- BTRFS as root filesystem with multiple subvolumes.

This document should be followed on top of the official
[Installation Guide](https://wiki.archlinux.org/title/installation_guide).

## Setup

### Prerequisites

- Prepare an installation medium and boot it with that environment.

- On UEFI:

  - Disable secure boot.

  - Change `SATA` Operation mode from `RAID` to `AHCI`. If dual-booting with
    Windows, follow
    [this step](https://support.thinkcritical.com/kb/articles/switch-windows-10-from-raid-ide-to-ahci)
    to continue using Win 10/11.

  - (For Dell only) Change `Fastboot` from `Minimal` to `Thorough` to perform
    complete hardware and configuration testing.

### Verify boot mode

Verify system is booted via UEFI by listing contents of efivars. If the
directory does not exist, the system is booted to BIOS. This document
requires the UEFI boot with the newer GPT (not MBR) disk partition.

```sh
ls /sys/firmware/efi/efivars || { echo 'boot not uefi!'; exit 1; }
```

### Network

Preferably, connect the Internet via wired connection. If it's not possible,
connect via Wi-Fi:

```sh
iwctl station list
iwctl station wlan0 get-networks
iwctl station wlan0 connect <ESSID>
```

Check the connection.

```sh
ping -c 3 archlinux.org
```

### SSH access

Optionally, access the machine over `ssh`, preferably from the same network:

1. Check if the ssh service is active: `systemctl status sshd`

1. Setup a root password which is needed for an SSH connection, since the
   default Arch password for root is empty: `passwd`

1. Get the target IP address: `ip route get 1 | awk '{ print $7 }'`

1. Connect with ssh with password (set no host key checking so get no MiTM
   attack warnings, etc.) for that ephemeral host:

```sh
ssh -o PubkeyAuthentication=no -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@<target-ip-address>
```

Under normal circumstances, connecting to an SSH server via password isn't
preferred over public key exchange but because this is an ephemeral server,
it's fine to proceed like that. Still choosing a strong password is
recommended.

## Preparation

### Disk partitions

Depending on disk type, names can be prefixed with different formats such as
`/dev/nvme<X>p<Y>`(NVMe), `/dev/sd<X>p<Y>` (SSD), `/dev/hd<X>p<Y>` (HDD), etc.

Show block devices.

```sh
fdisk -l
blkid
lsblk --fs
```

Declare the disk variable.

```sh
DISK='/dev/nvme0n1'
```

(Optional) Remove all partitions, signatures, and wipe up the whole disk.
Warning: this action is irreversible!

```sh
wipefs --all $DISK
sgdisk --zap-all --clear $DISK
partprobe $DISK
```

(Optional) Securely erasing a storage device. ! This method works if the device
is NVMe !

```sh
nvme list
nvme id-ctrl -H "$DISK"
hexdump "$DISK" | head -n10

# secure erase command
nvme format "$DISK" --ses=1
# Success formatting namespace:1

# reboot
reboot

# verify
timeout 3 hexdump "$DISK"
# 0000000 0000 0000 0000 0000 0000 0000 0000 0000
# *
```

Create partitions.

Partitions are created with the newer GPT rather than the old MBR. List
partition type codes with `sgdisk --list-types`.

1. **boot**: Note that there is no need to create a boot/EFI partition if
   there's already a boot partition available (usually there's one if you plan
   dual-booting). Arch wiki recommends min `~300M` for boot but in case there's
   more OSes added, better to keep it at `~1GiB`. gdisk code: `ef00 EFI system
   partition`.

1. **system**: encrypted system. Contains BTRFS subvolumes. gdisk code: `8309
   Linux LUKS`.

(If you have too much disk space, you can limit the cryptsystem size and leave
some more for future.)

```sh
sgdisk --clear \
  --new=1:0:+1G    --typecode=1:ef00 --change-name=1:EFI \
  --new=2:0:+300G  --typecode=2:8309 --change-name=2:cryptsystem \
  "$DISK"
partprobe "$DISK"
```

Check partitions.

```sh
sgdisk -p $DISK
lsblk
ls -l /dev/disk/by-partlabel
```

If everything is good, unset the variable, and just use part-labels onward.

```sh
unset DISK
```

### Format and encrypt partitions

Format boot/EFI.

```sh
mkfs.fat -F32 -n EFI /dev/disk/by-partlabel/EFI
```

Encrypt the system partition.

<!-- TODO: create a second passphrase in LUKS 32bit and keep it in backup in
case. -->

```sh
cryptsetup luksFormat /dev/disk/by-partlabel/cryptsystem
# Enter passphrase ...

cryptsetup open /dev/disk/by-partlabel/cryptsystem cryptsystem
# Enter passphrase ...
```

Format system partition, mount and create BTRFS subvolumes.

```sh
# Format btrfs
mkfs.btrfs /dev/mapper/cryptsystem
mount /dev/mapper/cryptsystem /mnt
# root `/` subvolume
btrfs subvolume create /mnt/@
btrfs subvolume set-default /mnt/@
# swap subvolume
btrfs subvolume create /mnt/@swap
# Create subvolumes
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@cache
btrfs subvolume create /mnt/@log
```

Check.

```sh
# verify subvolumes
btrfs subvolume list /mnt

# if all good, unmount
umount /mnt
```

### Mounts

Mount boot, system and BTRFS subvolumes. The order of mounts is important here
because later when fstab entries are generated, fstab reads from top to bottom.

```sh
# mount options
mount_opts_boot='fmask=0137,dmask=0027'
mount_opts_btrfs='rw,defaults,noatime,compress=zstd:1'
# mount root
mount -o "subvol=@,$mount_opts_btrfs" /dev/mapper/cryptsystem /mnt
# mount boot
mkdir /mnt/boot
mount -o "$mount_opts_boot" /dev/disk/by-partlabel/EFI /mnt/boot
# create subvol directories
mkdir -p /mnt/{home,.snapshots,var/cache,var/log}
# mount subvolumes
mount -o "subvol=@home,$mount_opts_btrfs" /dev/mapper/cryptsystem /mnt/home
mount -o "subvol=@snapshots,$mount_opts_btrfs" /dev/mapper/cryptsystem /mnt/.snapshots
mount -o "subvol=@cache,$mount_opts_btrfs" /dev/mapper/cryptsystem /mnt/var/cache
mount -o "subvol=@log,$mount_opts_btrfs" /dev/mapper/cryptsystem /mnt/var/log
# mount swap
mkdir /mnt/swap
mount -o "subvol=@swap" /dev/mapper/cryptsystem /mnt/swap
```

### Swap

Swap is important for an healthy system and other features such as hibernate.
The size of the swap should be at least be equal or larger than the physical
memory size (e.g. 10% to 20% more). If there is a plan to upgrade the physical
memory later, a bigger swap size should be chosen ahead of time, or just do
everything from scratch. Swap has no actual file system, it's raw addressable
memory.

Use swapfile instead of swap partition. Using an encrypted swap partition over
a swapfile inside the encrypted partition has a disadvantage that you have to
type an additional passphrase for the swap partition manually on every boot.

```sh
# swapsize. e.g. RAM is 16GiB + ~ %10 = ~18GiB
swapsize='18G' # <-- !! change !!
swapfile='/mnt/swap/swapfile'
```

If you use btrfs >= 6.1, then run:

```sh
btrfs filesystem mkswapfile --size "$swapsize" "$swapfile"
swapon "$swapfile"
```

or ELSE run:

```sh
# # create empty swap file
# touch "$swapfile"
# # set file permissions.
# chmod 600 "$swapfile"
# # disable CoW.
# chattr +C "$swapfile"
# # set swap filesize.
# fallocate --length "$swapsize" "$swapfile"
# # make swap and enable.
# mkswap "$swapfile"
# swapon "$swapfile"
```

Check swap.

```sh
cat /proc/swaps
swaplabel "$swapfile"
free -m
swapon --show
```

## Installation

First, update the keyring of the archiso if the mounted ISO isn't the most up
to date version:

```sh
pacman --noconfirm -Sy archlinux-keyring
```

Install base packages.

```sh
# install linux kernel(s)
pacstrap /mnt base linux linux-headers linux-lts linux-lts-headers linux-firmware

# !! install correct microcode - Intel or AMD CPU !!
# pacstrap /mnt intel-ucode
# pacstrap /mnt amd-ucode

# btrfs
pacstrap /mnt btrfs-progs

# essentials
pacstrap /mnt git openssh sudo vim curl wget
```

Generate the fstab to make the mounts persistent.

```sh
genfstab -U /mnt >> /mnt/etc/fstab

# check everything is here and correct boot, subvolumes, swap, etc.
cat /mnt/etc/fstab
```

### Chroot

Change to root in the mount. The following commands are from the chroot.

```sh
arch-chroot /mnt
```

Verify fstab entries.

```sh
findmnt --verify --verbose
```

Change hostname.

```sh
myhostname='' # <-- !! change !!
echo "$myhostname" > /etc/hostname
```

Create super user (don't create a separate `root` user).

```sh
user='' # <-- !! change !!
# create user with the home directory
useradd --create-home --groups wheel "$user"
# add user to sudoers
echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel
# set password
passwd "$user"
```

### Bootloader

Using the modern [systemd-boot](https://wiki.archlinux.org/title/systemd-boot).

```sh
bootctl --path=/boot install
```

Regenerate initramfs. Update `vim /etc/mkinitcpio.conf` as follows:

```
# ** update file `/etc/mkinitcpio.conf` **
MODULES=(btrfs)
BINARIES=(/usr/bin/btrfs)
HOOKS=(base udev autodetect keyboard keymap modconf block encrypt filesystems resume fsck)
```

Save and quit. Then update the initial ramdisk environment.

```sh
mkinitcpio -P
```

Create the boot entry.

```sh
system_partuuid="$(blkid -s PARTUUID -o value /dev/disk/by-partlabel/cryptsystem)"
microcode="$(find /boot -type f -name '*-ucode.img' -exec sh -c 'echo /$(basename {})' \;)"

cat << EOF > /boot/loader/entries/arch-linux.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  $microcode
initrd  /initramfs-linux.img
options cryptdevice=PARTUUID=$system_partuuid:cryptsystem root=/dev/mapper/cryptsystem rw
sort-key 1
EOF

cat << EOF > /boot/loader/entries/arch-linux-lts.conf
title   Arch Linux LTS (fallback)
linux   /vmlinuz-linux-lts
initrd  $microcode
initrd  /initramfs-linux-fallback.img
options cryptdevice=PARTUUID=$system_partuuid:cryptsystem root=/dev/mapper/cryptsystem rw
sort-key 2
EOF

# Set bootloader config
cat << EOF > /boot/loader/loader.conf
default arch-linux.conf
timeout 6
editor no
EOF
```

Check boot list.

```sh
bootctl list
```

Quit from `arch-chroot` with `exit` or <kbd>CTRL</kbd>+<kbd>D</kbd>.

### Desktop

Boot into container with `systemd-nspawn`. Using `-b` boots the container (i.e.
run systemd as PID=1). In order to quit from container, use `sudo poweroff`.

Login with `$user` and set password.

```sh
systemd-nspawn -b -D /mnt
```

Set the system clock. (system has to be booted with systemd)

```sh
timezone='Europe/Amsterdam'
sudo timedatectl set-ntp true
sudo timedatectl set-timezone "$timezone"
# check with
date
```

Install desktop environment, window and display manager, etc.

Install SDDM graphical display manager.

```sh
sudo pacman -S sddm
sudo systemctl enable sddm.service
```

Install KDE Plasma desktop environment (minimal).

```sh
sudo pacman -S plasma-meta kde-applications-meta
```

Network. Install NetworkManager (alternative is systemd-networkd).

```sh
sudo pacman -S networkmanager network-manager-applet
sudo systemctl enable NetworkManager
```

Disable NetworkManager-wait-online because it increases the boot time.

```sh
sudo systemctl disable NetworkManager-wait-online.service
sudo systemctl mask NetworkManager-wait-online.service
# enable systemd-resolved
sudo systemctl enable systemd-resolved
```

Enable systemd-resolved.

```sh
sudo systemctl enable systemd-resolved
```

## End

1. Exit systemd-nspawn with `sudo poweroff`.

2. Run below to turn off resources gracefully.

```sh
# turn off all swap
swapoff --all
# unmount all
umount -R /mnt
# close all open luks
cryptsetup luksClose cryptsystem
```

3. Shutdown with `shutdown now`.

4. Remove the ISO media (ie. pluggable devices) or choose from
   boot menu to boot the system.

5. Boot into the new system, login and continue with the post installation.

## References

- <https://wiki.archlinux.org/title/installation_guide>

- <https://wiki.archlinux.org/title/Dm-crypt/Swap_encryption#Using_a_swap_partition>

- <https://btrfs.readthedocs.io/en/latest/Swapfile.html>

- <https://wiki.archlinux.org/title/mkinitcpio#Common_hooks>
