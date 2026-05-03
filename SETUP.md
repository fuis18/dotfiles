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
```

---

### UEFI - ext4

| Device    | Size  | Type             | Label |
| --------- | ----- | ---------------- | ----- |
| /dev/sda1 | 1G    | EFI System       | boot  |
| /dev/sda2 | 100G  | Linux filesystem | root  |
| /dev/sda3 | resto | Linux filesystem | home  |
| /dev/sda4 | 4GB   | Linux swap       | swap  |

Nuevo sistema de archivos Btrfs

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

---

### UEFI - Btrfs

| Device    | Size  | Type             | Label |
| --------- | ----- | ---------------- | ----- |
| /dev/sda1 | 1G    | EFI System       | boot  |
| /dev/sda2 | resto | Linux filesystem | root  |
| /dev/sda3 | 4GB   | Linux swap       | swap  |


```sh
lsblk

# EFI
mkfs.fat -F 32 /dev/sda1
# Root (Btrfs)
mkfs.btrfs -L root /dev/sda2
# Swap
mkswap /dev/sda3
```

#### Crear subvolúmenes

```sh
# Montar root temporalmente para crear subvolúmenes
mount /dev/sda2 /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@cache

umount /mnt
```

#### Montar subvolúmenes


```sh
# Opciones recomendadas para Btrfs
OPTS="noatime,compress=zstd,space_cache=v2,commit=120"

# Root (@)
mount -o ${OPTS},subvol=@ /dev/sda2 /mnt

# Home (@home)
mkdir -p /mnt/home
mount -o ${OPTS},subvol=@home /dev/sda2 /mnt/home

# Snapshots
mkdir -p /mnt/.snapshots
mount -o ${OPTS},subvol=@snapshots /dev/sda2 /mnt/.snapshots

# Logs
mkdir -p /mnt/var/log
mount -o ${OPTS},subvol=@log /dev/sda2 /mnt/var/log

# Cache
mkdir -p /mnt/var/cache
mount -o ${OPTS},subvol=@cache /dev/sda2 /mnt/var/cache

# EFI
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

# Swap
swapon /dev/sda3
```

#### Verificar montaje

```sh
mount | grep /mnt
lsblk -f
```

---

### GRUB

| Device    | Size  | Type             | Label |
| --------- | ----- | ---------------- | ----- |
| /dev/sda1 | 2M    | BIOS boot        | boot  |
| /dev/sda2 | 100G  | Linux filesystem | root  |
| /dev/sda3 | resto | Linux filesystem | home  |
| /dev/sda4 | 4G    | Linux swap       | swap  |

```sh
lsblk

# Root
mkfs.ext4 /dev/sda2
# Home
mkfs.ext4 /dev/sda3
# Swap
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

## Pacstrap

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

> Para Btrfs, instalar también: `pacstrap /mnt btrfs-progs`

#### Genfstab

```sh
rm /mnt/etc/fstab

genfstab -U /mnt >> /mnt/etc/fstab
```

### arch-chroot

```sh
arch-chroot /mnt

mount | grep boot
```

#### Snapper (Only Btrfs)

Snapper no puede crear la config si `@snapshots` ya está montado en `/.snapshots`. El truco es desmontarlo desde el **USB live** (con prefijo `/mnt`), dejar que snapper cree su propio subvolumen, borrarlo, y volver a montar `@snapshots`.

Instalar dentro del chroot:

```sh
pacman -S snapper snap-pac
```

Salir del chroot y hacer el intercambio desde el USB live:

```sh
exit

# 1. Desmontar @snapshots
umount /mnt/.snapshots
rm -rf /mnt/.snapshots

# 2. Volver al chroot y crear la config
arch-chroot /mnt
snapper -c root create-config /

# 3. Salir y borrar el subvolumen que creó snapper
exit
btrfs subvolume delete /mnt/.snapshots

# 4. Remontar @snapshots
mkdir -p /mnt/.snapshots
chmod 750 /mnt/.snapshots
mount -o noatime,compress=zstd,space_cache=v2,subvol=@snapshots /dev/sda2 /mnt/.snapshots

# 5. Volver al chroot para continuar
arch-chroot /mnt
```

```sh
# Activar timers
systemctl enable snapper-timeline.timer
systemctl enable snapper-cleanup.timer
```

#### Desactivar y desmontar

```sh
swapoff /mnt/swapfile
umount -R /mnt
umount -l /mnt
umount /mnt/home
```

### Swap (zram)

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

daemon-reload

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
# /boot/EFI/BOOT:
#   BOOTX64.EFI
# /boot/EFI/Linux:
#
# /boot/EFI/systemd:
# systemd-bootx64.efi
# /boot/loader:
#   entries entries.srel keys loader.conf random-seed
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
blkid /dev/sda2
# blkid -s UUID -o value /dev/sda2
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
initrd  /initramfs-linux-zen.img
options root=UUID=TU_UUID rw
EOF
```

> Para Btrfs, agregar al final de `options`:
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

bootctl list
```

## End

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

exit
reboot
```
