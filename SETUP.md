# SETUP

In Virtual Machine active UEFI

## Installation

```sh
# localectl list-keymaps
loadkeys la-latin1

# ip link
iwctl

station list scan
station wlan0 connect "Your_wifi"
exit

ping -c 5 archlinux.org
```

## Keyring

```sh
pacman-key --init
pacman-key --populate archlinux

pacman -Sy archlinux-keyring
sudo pacman -Sy
```

## Partition

```sh
cfdisk
# cfdisk /dev/nvme0n1
```

---

### UEFI - ext4

| Device    | Size  | Type             | Label |
| --------- | ----- | ---------------- | ----- |
| /dev/sda1 | 1G    | EFI System       | boot  |
| /dev/sda2 | 100G  | Linux filesystem | root  |
| /dev/sda3 | 4GB   | Linux swap       | swap  |
| /dev/sda4 | resto | Linux filesystem | home  |

```sh
lsblk

# primary
mkfs.fat -F 32 /dev/sda1
# root
mkfs.ext4 /dev/sda2
# swap
mkswap /dev/sda3
# home
mkfs.ext4 /dev/sda4
```

```sh
# root
mkdir -p /mnt
mount /dev/sda2 /mnt

# UEFI
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

# home
mkdir -p /mnt/home
mount /dev/sda4 /mnt/home
# swap
swapon /dev/sda3
```

---

### UEFI - Btrfs

| Device    | Size  | Type             | Label |
| --------- | ----- | ---------------- | ----- |
| /dev/sda1 | 1G    | EFI System       | boot  |
| /dev/sda2 | 4GB   | Linux swap       | swap  |
| /dev/sda3 | resto | Linux filesystem | root  |

```sh
lsblk

# EFI
mkfs.fat -F 32 /dev/sda1
# Swap
mkswap /dev/sda2
# Root (Btrfs)
mkfs.btrfs -L root /dev/sda3
```

#### Create subvolumes

```sh
mount /dev/sda3 /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@cache
btrfs subvolume create /mnt/@tmp

umount /mnt
```

#### Mount subvolumes

```sh
OPTS="noatime,compress=zstd,space_cache=v2,commit=120"

mkdir -p /mnt/home
mkdir -p /mnt/.snapshots
mkdir -p /mnt/var/log
mkdir -p /mnt/var/cache
mkdir -p /mnt/boot

mount -o ${OPTS},subvol=@ /dev/sda3 /mnt
mount -o ${OPTS},subvol=@home /dev/sda3 /mnt/home
mount -o ${OPTS},subvol=@snapshots /dev/sda3 /mnt/.snapshots
mount -o ${OPTS},subvol=@log /dev/sda3 /mnt/var/log
mount -o ${OPTS},subvol=@cache /dev/sda3 /mnt/var/cache
mount -o ${OPTS},subvol=@tmp /dev/sda3 /mnt/var/tmp
```

#### Mount remaining partitions

```sh
# EFI
mount /dev/sda1 /mnt/boot

# Swap
swapon /dev/sda2

# Check
findmnt -t btrfs
```

---

### GRUB

| Device    | Size  | Type             | Label |
| --------- | ----- | ---------------- | ----- |
| /dev/sda1 | 2M    | BIOS boot        | boot  |
| /dev/sda2 | 100G  | Linux filesystem | root  |
| /dev/sda3 | 4G    | Linux swap       | swap  |
| /dev/sda4 | resto | Linux filesystem | home  |

```sh
lsblk

# Root
mkfs.ext4 /dev/sda2
# Swap
mkswap /dev/sda3
# Home
mkfs.ext4 /dev/sda4
```

```sh
# root
mkdir -p /mnt
mount /dev/sda2 /mnt
# swap
swapon /dev/sda3
# home
mkdir -p /mnt/home
mount /dev/sda4 /mnt/home
```

## Pacstrap

#### Check assembly Mount

```sh
mount | grep /mnt
lsblk -f
```

```sh
pacstrap -K /mnt base linux-zen linux-zen-headers linux-firmware
pacstrap /mnt sudo nvim git iwd dhcpcd knot-resolver less

vim /mnt/etc/vconsole.conf
```

```conf
KEYMAP=la-latin1
XKBLAYOUT=latam
```

```sh
ls /mnt/boot
ls /mnt/lib/modules

# CPU
lscpu | less
```

| Intel                       | AMD                       |
| --------------------------- | ------------------------- |
| `pacstrap /mnt intel-ucode` | `pacstrap /mnt amd-ucode` |

> For Btrfs, also install: `pacstrap /mnt btrfs-progs`

#### Genfstab

```sh
rm /mnt/etc/fstab

genfstab -U /mnt >> /mnt/etc/fstab
```

### Helper: Disable and Unmount

```sh
swapoff /mnt/swapfile
umount -R /mnt
umount -l /mnt
umount /mnt/home
```

### arch-chroot

```sh
arch-chroot /mnt

mount | grep boot
```

#### Snapper (Only Btrfs)

```sh
pacman -S snapper snap-pac
```

### Swap (zram)

```sh
swapon --show
```

### zram

- For 4GB of ram use .5, obtain 6GB
- For 6GB of ram use .5, obtain 9GB
- For 8GB of ram use .5, obtain 12GB
- For 16GB of ram use 1, obtain 32GB
- For 32GB of ram use 1, obtain 64GB
- For 64GB of ram use .5, obtain 96GB

```sh
free -h
pacman -S zram-generator

nvim /etc/systemd/zram-generator.conf
```

```conf
[zram0]
zram-size = ram * 0.5
compression-algorithm = zstd
swap-priority = 150
```

```sh
nvim /etc/sysctl.d/99-swappiness.conf
```

```conf
vm.swappiness=100
# 150 less cache saved
vm.vfs_cache_pressure=150
```

## Bootloader

### GRUB (BIOS)

```sh
pacman -S grub
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```

### systemd-boot (UEFI)

```sh
# rm /boot/loader/entries/*.conf

bootctl install

bootctl

# /boot//EFI/systemd/systemd-bootx64.efi
# /boot//EFI/BOOT/BOOTX64.EFI
# /boot//loader/loader.conf

ls -R /boot

# /boot:
#   EFI initramfs-linux-zen.img intel-ucode.img loader vmlinuz-linux-zen
# /boot/EFI:
#   BOOT Linux systemd
#
# /boot/EFI/BOOT:
#   BOOTX64.EFI
#
# /boot/EFI/Linux:
#
# /boot/EFI/systemd:
# systemd-bootx64.efi
#
# /boot/loader:
#   entries entries.srel keys loader.conf random-seed
#
# /boot/loader/entries:
#
# /boot/loeader/keys:
#

cat > /boot/loader/loader.conf <<EOF
default  arch.conf
timeout  3
console-mode max
editor   no
EOF

# UUID
blkid /dev/sda3
# blkid -s UUID -o value /dev/sda3
```

```sh
# Intel
cat > /boot/loader/entries/arch.conf <<EOF
title   Arch Linux
linux   /vmlinuz-linux-zen
initrd  /intel-ucode.img
initrd  /initramfs-linux-zen.img
options root=UUID=TU_UUID rootflags=subvol=@ rw
EOF

# AMD
cat > /boot/loader/entries/arch.conf <<EOF
title   Arch Linux
linux   /vmlinuz-linux-zen
initrd  /amd-ucode.img
initrd  /initramfs-linux-zen.img
options root=UUID=TU_UUID rw
EOF

bootctl list
```

> For Btrfs, add to the end of `options`:
>
> ```
> options root=UUID=TU_UUID rootflags=subvol=@ rw
> ```

Editar fstab:

```sh
nvim /etc/fstab

# /dev/sda1
UUID=XXXX-XXXX  /boot  vfat  rw,relatime,fmask=0077,dmask=0077,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro  0  2
```

```sh
mkinitcpio -P
```

## End

```sh
passwd
admin18 # root password
useradd -m fuis18
passwd fuis18
luis18 # user password

usermod -aG wheel fuis18
groups fuis18
getent group fuis18

# ~/.cache as a separate subvolume
btrfs subvolume create /home/fuis18/.cache
chown -R fuis18:fuis18 /home/fuis18/.cache

echo hacker > /etc/hostname

# enable sudo for wheel group
EDITOR=nvim visudo

# %wheel ALL=(ALL:ALL) ALL

nvim /etc/hosts
127.0.0.1  localhost
::1        localhost
127.0.0.1  hacker.localhost hacker

systemctl enable iwd knot-resolver

ln -sf /usr/share/zoneinfo/America/Lima /etc/localtime
hwclock --systohc
date

timedatectl set-ntp true
# systemctl status systemd-timesyncd

# or: localectl set-locale LANG=en_US.UTF-8
nvim /etc/locale.conf
# LANG=en_US.UTF-8
locale
```

```sh
exit
reboot
```
