# SETUP

## Instalation

```sh
# localectl list-keymaps
loadkeys la-latin1

# ip link
iwctl

station list scan
station wlan0 connect "Your_wifi"
exit

ping www.archlinux.org
```

### Keyring

```sh
pacman-key --init
pacman-key --populate archlinux

pacman -Sy archlinux-keyring
sudo pacman -Sy
```

### Partition

```sh
cfdisk
```

#### UEFI

| Device    | Size  | Type             | Label |
| --------- | ----- | ---------------- | ----- |
| /dev/sda1 | 1G    | EFI System       | boot  |
| /dev/sda2 | 100G  | Linux filesystem | root  |
| /dev/sda3 | resto | Linux filesystem | home  |
| /dev/sda4 | 5GB   | Linux swap       | swap  |

```sh
lsblk

# Primary
mkfs.fat -F 32 /dev/sda1
# Root
mkfs.ext4 /dev/sda2
# Home
mkfs.ext4 /dev/sda3
# swap
mkswap /dev/sda4
```

```sh
# Montar root
mkdir -p /mnt
mount /dev/sda2 /mnt

# Montar UEFI
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

# Montar home
mkdir -p /mnt/home
mount /dev/sda3 /mnt/home
# swap
swapon /dev/sda4
```

#### GRUB

| Device    | Size  | Type             | Label |
| --------- | ----- | ---------------- | ----- |
| /dev/sda1 | 2M    | BIOS boot        | boot  |
| /dev/sda2 | 100G  | Linux filesystem | root  |
| /dev/sda3 | resto | Linux filesystem | home  |
| /dev/sda4 | 4G    | Linux swap       | swap  |

```sh
lsblk

# root
mkfs.ext4 /dev/sda2
# home
mkfs.ext4 /dev/sda3
# swap
mkswap /dev/sda4
```

```sh
mkdir -p /mnt
mount /dev/sda2 /mnt

mkdir -p /mnt/home
mount /dev/sda3 /mnt/home
# swap
swapon /dev/sda4
```

### Pacstrap

```sh
lsblk -f

mount | grep mnt
```

```sh
pacstrap -K /mnt base linux-zen linux-zen-headers linux-firmware
pacstrap /mnt networkmanager sudo nvim git

nvim /mnt/etc/vconsole.conf
```

```conf
KEYMAP=la-latin1
XKBLAYOUT=latam
```

```sh
ls /mnt/boot
ls /mnt/lib/modules

# CPU
lscpu
```

| Intel                       | AMD                       |
| --------------------------- | ------------------------- |
| `pacstrap /mnt intel-ucode` | `pacstrap /mnt amd-ucode` |

### Genfstab

```sh
rm /mnt/etc/fstab

genfstab -U /mnt >> /mnt/etc/fstab
```

### arch-chroot

```sh
arch-chroot /mnt

mount | grep boot
```

#### Desactivar

```sh
swapoff /mnt/swapfile
umount -R /mnt
umount -l /mnt
umount /mnt/home
```

### Swap

```sh
swapon --show
```

```sh
pacman -S zram-generator

nvim /etc/systemd/zram-generator.conf
```

```conf
[zram0]
zram-size = ram * 0.75
compression-algorithm = zstd
swap-priority = 100
```

```sh
nvim /etc/sysctl.d/99-swappiness.conf
```

```sh
vm.swappiness=100
```

### Bootloader

#### GRUB

```sh
pacman -S grub
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
```

#### UEFI

```sh
# rm /boot/loader/entries/*.conf

mount -o remount,rw /boot
daemon-reload

bootctl install

bootctl

# /boot/EFI/systemd/systemd-bootx64.efi
# /boot/loader/loader.conf
# /boot/loader/entries/

ls -R /boot

# /boot:
#   EFI initramfs-linux.img intel-ucode.img loader vmlinuz-linux
# /boot/EFI:
#   BOOT Linux systemd
# /boot/EFI/BOOT:
#   BOOTX64.EFI
# /boot/loader:
#   entries entries.srel keys loader.conf random-seed
# /boot/loader/entries:
#   arch.conf

cat > /boot/loader/loader.conf <<EOF
default  arch.conf
timeout  3
console-mode max
editor   no
EOF

# UUID
blkid /dev/sda2

# blkid -s PARTUUID -o value /dev/sda2
```

```sh
# Intel
cat > /boot/loader/entries/arch.conf <<EOF
title   Arch Linux
linux   /vmlinuz-linux-zen
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=UUID=TU_UUID rw
EOF

# AMD
cat > /boot/loader/entries/arch.conf <<EOF
title   Arch Linux
linux   /vmlinuz-linux-zen
initrd  /amd-ucode.img
initrd  /initramfs-linux.img
options root=UUID=TU_UUID rw
EOF
```

Editar fstab:

```sh
nvim /etc/fstab

# /dev/sda1
UUID=XXXX-XXXX  /boot  vfat  defaults,relatime,fmask=0077,dmask=0077,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro  0  2
```

```sh
mkinitcpio -P

bootctl update
mount -o remount,ro /boot
```

### Final

```sh
passwd
admin18 # root password
useradd -m -G wheel fuis18
passwd fuis18
luis18 # user password

usermod -aG wheel fuis18
groups fuis18

echo hacker > /etc/hostname

EDITOR=nvim visudo       # habilitar sudo para grupo wheel

# %wheel ALL=(ALL:ALL) ALL

nvim /etc/hosts
127.0.0.1  localhost
::1        localhost
127.0.0.1  hacker.localhost hacker

ln -sf /usr/share/zoneinfo/America/Lima /etc/localtime
hwclock --systohc
date

systemctl enable NetworkManager
```

```sh
bootctl list

exit
reboot
```
