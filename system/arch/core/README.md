## Introduction

My notes of Arch Linux installation.

- Boot with `systemd-boot` via UEFI.

- GPT partition table with two partitions: boot and LUKS encrypted
  system.

- btrfs as root filesystem with multiple subvolumes.

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

Connect to Wi-Fi.

```sh
iwctl station list
iwctl station wlan0 get-networks
iwctl station wlan0 connect <ESSID>
```

Check the connection.

```sh
ping archlinux.org -c 1
```

### SSH access

Optionally, access the machine over `ssh` from the same network:

1. Check if the ssh service is active: `systemctl status sshd`

1. Setup a root password which is needed for an SSH connection, since the
   default Arch password for root is empty: `passwd`

1. Get the target IP address: `ip route get 1 | awk '{ print $7 }'`

1. Connect with ssh with password (set no host key checking so get no MiTM
   attack warnings, etc.) for that ephemeral host:

```sh
ssh -o PubkeyAuthentication=no -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@<target-ip-address>
```

## Preparation

### Disk partitions

<!--
TODO use labels instead of partition disks because they can break if partitions
change
-->

Depending on disk type, names can be prefixed with different formats such as
`/dev/nvme<X>p<Y>`(NVMe), `/dev/sd<X>p<Y>` (SSD), `/dev/hd<X>p<Y>` (HDD), etc.

Show block devices.

```sh
fdisk -l
blkid
lsblk --fs -o +PARTLABEL
```

Declare the disk variable.

```sh
DISK="/dev/sda0"
```

(optional) remove all partitions, signatures, and wipe up the whole disk. Warning: this
action is irreversible!

```sh
wipefs --all "$DISK"
sgdisk --zap-all --clear "$DISK"
partprobe "$DISK"
```

Create partitions.

Partitions are created with the newer GPT rather than the old MBR. List
partition type codes with `sgdisk --list-types`.

1. **boot**: Note that there is no need to create a boot/EFI partition if
  there's already a boot partition available (usually there's one if you plan
  dual-booting). Arch wiki recommends min `~300M` for boot but in case there's
  more OSes added, better to keep it at 1GB. GPT: `ef00` EFI system partition.

2. **system**: encrypted system. Contains subvolumes. GPT: `8309` Linux LUKS.

```sh
sgdisk --clear \
  --new=1:0:+1GiB --typecode=1:ef00 --change-name=1:EFI \
  --new=2:0:0     --typecode=2:8309 --change-name=2:cryptsystem \
  "$DISK"
partprobe "$DISK"
```

Check partitions.

```sh
sgdisk -p "$DISK"
```

### Format partitions

1. Format boot/EFI.

```sh
mkfs.fat -F32 "${DISK}p1"
```

2. Format the system (main encrypted partition).

Prepare LUKS.

```sh
# create crypt.
cryptsetup luksFormat "${DISK}p2"
# ... set a passphrase.
# open crypt.
cryptsetup open "${DISK}p2" cryptsystem
# ... enter the passphrase.
```

btrfs filesystem with one main encrypted partition: system. With btrfs, it's
not *needed* to create separate partitions for different directories, use
subvolumes. It's told that btrfs is more performant than ext4 because of many
reasons like CoW; however, it's less stable.

Format disk, mount and create btrfs subvolumes.

```sh
# format btrfs.
mkfs.btrfs /dev/mapper/cryptsystem
mount /dev/mapper/cryptsystem /mnt
# root `/` subvolume.
btrfs subvolume create /mnt/@
btrfs subvolume set-default /mnt/@
# swap subvolume.
btrfs subvolume create /mnt/@swap
# create subvolumes.
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
# unmount.
umount /mnt
```

### Mounts

Mount options:

- `noatime`: Increases performance and reduces SSD writes.

- `compress=zstd:1`: `:1` is optimal for NVMe devices or use default value of
  `:3`.

```sh
mount_opts_btrfs="rw,defaults,noatime,compress=zstd:1"
# mount cryptsystem.
mount -o "subvol=@,$mount_opts_btrfs" /dev/mapper/cryptsystem /mnt
# mount boot
mkdir /mnt/boot
mount "${DISK}p1" /mnt/boot
# mount swap
mkdir /mnt/swap
mount -o "subvol=@swap,$btrfs_mount_opts" /dev/mapper/cryptsystem /mnt/swap
# mount subvolumes.
mkdir -p /mnt/{home,.snapshots}
mount -o "subvol=@home,$btrfs_mount_opts" /dev/mapper/cryptsystem /mnt/home
mount -o "subvol=@snapshots,$btrfs_mount_opts" /dev/mapper/cryptsystem /mnt/.snapshots
```

### Swap

<!--
XXX: make swap a separate encrypted partition unlocked at boot.
Update.
/boot/loader/entries/arch.conf
and
Update `/etc/crypttab` to unlock the encrypted swap at boot.
-->

Swap is needed for an healthy system and other features such as hibernate. The
size of the swap should be at least be equal or larger than the physical memory
size (e.g. 10% to 20% more). If there is a plan to upgrade the physical memory
later, a bigger swap size should be chosen ahead of time, or just do everything
from scratch.

With btrfs, swap doesn't have to be in a separate partition, a subvolume is
fine.

```sh
# swapsize. e.g. RAM is 16GiB + ~ %10 = ~18GiB
swapsize="16GiB" # <-- !! change !!
swapfile="/mnt/swap/swapfile"
# create empty swap file
touch "$swapfile"
# set file permissions.
chmod 600 "$swapfile"
# disable CoW.
chattr +C "$swapfile"
# set swap filesize.
fallocate --length "$swapsize" "$swapfile"
# make swap and enable.
mkswap "$swapfile"
swapon "$swapfile"

# check swap
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
# Install Linux kernel both `linux` or `linux-lts`. You choose one in the boot
# loader below.
pacstrap /mnt base linux linux-headers linux-lts linux-lts-headers linux-firmware
# !! select correct microcode !!
# microcode: intel:
# pacstrap /mnt intel-ucode
# microcode: amd:
pacstrap /mnt amd-ucode
# btrfs.
pacstrap /mnt btrfs-progs
# utils.
pacstrap /mnt dhcpcd iwd openssh vim git
```

Generate the fstab to make the mounts persistent.

```sh
genfstab -U /mnt >> /mnt/etc/fstab
```

### Chroot

Change to root in the mount. The following commands are from the chroot.

```sh
arch-chroot /mnt
```

Verify fstab entries

```sh
findmnt --verify --verbose
```

Change hostname.

```sh
myhostname="" # <-- !! change !!
echo "$myhostname" > /etc/hostname
```

Create super user. (Don't create a separate `root` user.)

```sh
user="" # <-- !! change !!
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
# systemd, sd-vconsole and sd-encrypt are replaced by udev, keymap and encrypt
HOOKS=(base udev autodetect keyboard keymap modconf block encrypt filesystems resume fsck)
```

Then update with `mkinitcpio -P`.

Create the boot entry.

```sh
system_part="/dev/sda2" # <-- !! change !!
system_partuuid="$(blkid -s PARTUUID -o value $system_part)"
system_luks_label="cryptsystem"
# !! select correct microcode !!
# microcode="/intel-ucode.img"
microcode="/amd-ucode.img"

cat << EOF > /boot/loader/entries/arch-linux.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  $microcode
initrd  /initramfs-linux.img
options cryptdevice=PARTUUID=$system_partuuid:cryptsystem root=/dev/mapper/$system_luks_label rw
EOF

cat << EOF > /boot/loader/entries/arch-linux-lts.conf
title   Arch Linux LTS (fallback)
linux   /vmlinuz-linux-lts
initrd  $microcode
initrd  /initramfs-linux-fallback.img
options cryptdevice=PARTUUID=$system_partuuid:cryptsystem root=/dev/mapper/$system_luks_label rw
EOF

# Set bootloader config
cat << EOF > /boot/loader/loader.conf
default arch-linux
timeout 4
editor no
EOF
```

Check boot list.

```sh
bootctl list
```

Enable Internet connection for the next boot.

```sh
systemctl enable dhcpcd iwd
```

Leave chroot and reboot.

1. Exit chroot with `exit` or <kbd>CTRL</kbd>+<kbd>D</kbd>.

2. Run below to exit gracefully.

```sh
swapoff "$swapfile"  # disable swap
umount -R /mnt  # unmount all
cryptsetup luksClose /dev/mapper/cryptsystem  # close LUKS
```

3. Shutdown with `shutdown now`.

4. Remove the ISO media (ie. pluggable devices) or choose from
   boot menu to boot the system.

## Post-installation

Boot into the new system, login and continue with the post installation.

Set the system clock. (system has to be booted with systemd)

```sh
timezone="Europe/Amsterdam"
sudo timedatectl set-ntp true
sudo timedatectl set-timezone "$timezone"
# check with
date
```

### Desktop

Install desktop environment, window and display manager, etc.

Install and setup lightdm.

```sh
sudo pacman -S lightdm lightdm-gtk-greeter
```

Set the default greeter by changing the [Seat:*] section of the LightDM
configuration file
`vim /etc/lightdm/lightdm.conf`

[Seat:*]
...
greeter-session=lightdm-gtk-greeter
...

Enable the lightdm service.

```sh
sudo systemctl enable lightdm
```

Install KDE.

```sh
sudo pacman -S xorg-server xorg-xinit xfce4
```

Network.

```sh
sudo pacman -S networkmanager network-manager-applet
# disable iwd and dhcpcd.
sudo systemctl disable iwd
sudo systemctl disable dhcpcd
# enable network manager (alternative is systemd-networkd).
sudo systemctl enable NetworkManager
# disable network manager wait online because it increases the boot time.
# enable it back if it causes problems with any services.
sudo systemctl disable NetworkManager-wait-online.service
sudo systemctl mask NetworkManager-wait-online.service
# enable systemd-resolved
sudo systemctl enable systemd-resolved
```

Sound. Pipewire.

```sh
sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber alsa-utils
systemctl --user enable --now pipewire-pulse.service

# test
pactl info | grep PipeWire
speaker-test -c 2 -t wav -l 1
```

## End

Reboot now with `sudo reboot`.
