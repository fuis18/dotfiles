# MY DOT FILES

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

| Device    | Size  | Type             | Label |
| --------- | ----- | ---------------- | ----- |
| /dev/sda1 | 1G    | EFI System       | boot  |
| /dev/sda2 | 100G  | Linux filesystem | root  |
| /dev/sda3 | resto | Linux filesystem | home  |

| Device    | Size  | Type             | Label |
| --------- | ----- | ---------------- | ----- |
| /dev/sda1 | 100G  | Linux filesystem | root  |
| /dev/sda2 | resto | Linux filesystem | home  |

write
quit

### Formating

```sh
lsblk

# Primary
mkfs.fat -F 32 /dev/sda1
# Root
mkfs.ext4 /dev/sda2
# Home
mkfs.ext4 /dev/sda3
```

### Mounts (El orden importa)

#### UEFI

```sh
# Montar root
mount /dev/sda2 /mnt

# Montar UEFI
mkdir -p /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

# Montar MRB
mkdir -p /mnt/
mount /dev/sda1 /mnt/

# Montar home
mkdir -p /mnt/home
mount /dev/sda3 /mnt/home
```

#### GRUB

```sh
mount /dev/sda1 /mnt/

mkdir -p /mnt/home
mount /dev/sda2 /mnt/home
```

```sh
lsblk -f

mount | grep mnt
```

### Pacstrap

```sh
pacstrap -K /mnt base base-devel linux linux-firmware
pacstrap /mnt networkmanager sudo nvim git

nvim /mnt/etc/vconsole.conf
KEYMAP=la-latin1
XKBLAYOUT=latam

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
# Crear el archivo con 10G
fallocate -l 10G swapfile

chmod 700 swapfile
mkswap swapfile
swapon swapfile

swapon --show

nvim /etc/fstab
```

Editar fstab:

```sh
/swapfile none swap defaults 0 0
```

### bootloader

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
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=UUID=TU_UUID rw
EOF

# AMD
cat > /boot/loader/entries/arch.conf <<EOF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /amd-ucode.img
initrd  /initramfs-linux.img
options root=UUID=TU_UUID rw
EOF
```

Editar fstab:

```sh
nvim /etc/fstab

# /dev/sda1
UUID=XXXX-XXXX  /boot  vfat  ro,relatime,fmask=0077,dmask=0077,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro  0  2
```

```sh
mkinitcpio -P

bootctl update
mount -o remount,ro /boot
```

### final

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

nvim /etc/host
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

## Install

### NetworkManager

```sh
sudo pacman -Sy

sudo systemctl start NetworkManager.service
sudo systemctl enable --now NetworkManager.service
nmcli device
nmcli device wifi connect "SSID" password "tu_contraseña"
```

### My files

```sh
sudo su
pacman -S git
mkdir -p Downloads/repos/fuis18
cd Downloads/repos/fuis18/
git clone https://github.com/fuis18/dotfiles.git

sudo bash dotfiles/install_system.sh 
sudo bash dotfiles/install_personal-1.sh
sudo bash dotfiles/install_personal-2.sh
sudo bash dotfiles/install_personal-3.sh
bash dotfiles/install_normal.sh
```

## PACKAGES

| Label               | Package                |
| ------------------- | ---------------------- |
| General             | git wget unzip makepkg |
| Login Manager       | tuigreet               |
| Protocol            | wayland                |
| Window Manager      | hyprland               |
| Lock Screen         | hyprlock + tauri       |
| Notificación        | swaync libnotify       |
| Terminal            | kitty                  |
| Shell               | zsh                    |
| customizable prompt | starship               |
| Editor              | nvim                   |
| File Manager        | yazi                   |
| Launcher            | yofi                   |
| Status bar          | waybar -> ironbar      |
| Widgets             | eww-wayland            |
| bluetooth           | bluetui                |
| bluetooth back      | bluez bluez-utils      |
| Network             | nmcli                  |
| Network back        | networkmanager         |
| Audio               | cava                   |
| Audio back          | pipewire               |
| Power Options       | wlogout                |
| Screenshot          | grim slurp swappy      |
| Brillo              | brightnessctl          |
| System monitor      | btop                   |

### Adicionales

| Label          | Package             |
| -------------- | ------------------- |
| Logo           | fastfetch           |
| Documentación  | man                 |
| Buscador       | locate              |
| Browser        | librewolf           |
| Descomprimidor | unzip               |
| Remover        | scrub shred         |
| matrix         | cmatrix             |
| plugin cat     | bat                 |
| plugin ls      | lsd                 |
| Buscador       | fzf                 |
| Fonts          | FiraCode Nerd Fonts |
| Imagenes       | swayimg             |

### Other

Editar imagenes:

- Gimp
- Inkscape

Redes:

- Discord

Programación:

- Bun
- docker
