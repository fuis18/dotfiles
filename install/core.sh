#!/bin/bash

# Handle Errors
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Use sudo, need the root"
  exit 1
fi

USER_NAME=$(logname)
USER_HOME="/home/${USER_NAME}"
USER_REPOS="${USER_HOME}/Downloads/repos"
FUIS_REPO="${USER_REPOS}/fuis18/dotfiles"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ===== Snapper (Btrfs config) ====="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

# Solo aplica si root es Btrfs y @snapshots quedó registrado en fstab
# (ver SETUP.md). En ext4/GRUB layout esto se salta sin hacer nada.
if findmnt -no FSTYPE / | grep -q btrfs && grep -q ' /.snapshots ' /etc/fstab; then
  if [[ -f /etc/snapper/configs/root ]]; then
    echo -e "${GREEN}[!] Config de snapper 'root' ya existe, saltando.${RESET}"
  else
    echo "-> Liberando el punto de montaje /.snapshots"
    umount /.snapshots
    rm -rf /.snapshots

    echo "-> Creando la config real con snapper"
    snapper -c root create-config /

    echo "-> Descartando el subvolumen que snapper acaba de crear"
    umount /.snapshots
    btrfs subvolume delete /.snapshots
    mkdir -p /.snapshots

    echo "-> Montando el @snapshots definitivo (vía fstab)"
    mount /.snapshots
    chmod 750 /.snapshots

    if ! grep -q '^SNAPPER_CONFIGS="root"' /etc/conf.d/snapper 2>/dev/null; then
      echo 'SNAPPER_CONFIGS="root"' >/etc/conf.d/snapper
    fi

    systemctl enable --now snapper-timeline.timer
    systemctl enable --now snapper-cleanup.timer

    echo -e "${GREEN}[✔] Snapper listo, snap-pac capturará desde aquí.${RESET}"
  fi
else
  echo -e "${GREEN}[!] No es Btrfs o no hay /.snapshots en fstab, saltando snapper.${RESET}"
fi

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ===== Installing Base System ====="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm base-devel \
  devtools \
  wayland \
  xdg-desktop-portal \
  xdg-desktop-portal-gtk

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ========= Hyprland Shell ========="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm hyprland \
  hyprlock \
  hypridle \
  hyprpolkitagent \
  xdg-desktop-portal-hyprland

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ============== Core =============="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm wget openssh openssl \
  gtk4 gtk4-layer-shell pkg-config \
  qt6ct qt6-base qt6-declarative qt6-wayland qt5-wayland \
  upower gnome-keyring xsettingsd

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ============ Drivers ============"
echo -e "${BLUE} ================================="
echo -e "${RESET}"
echo ""

pacman -S --noconfirm libva
pacman -S --noconfirm v4l2loopback-dkms

# Intel
pacman -S --noconfirm libva-intel-driver intel-media-driver
# AMD
pacman -S --noconfirm mesa libva-mesa-driver libvdpau-va-gl mesa-utils
# vulkan-radeon lib32-vulkan-radeon
# NVidia
# pacman -S --noconfirm nvidia-utils libva-vdpau-driver

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ===== Network Configuration ====="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm bluez bluez-utils dbus

systemctl enable bluetooth
systemctl start bluetooth

pacman -S --noconfirm impala bluetui

# Segurity

pacman -S --noconfirm ufw

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} =========== AUR Helper ==========="
echo -e "${BLUE} =================================="
echo -e "${RESET}"
echo ""

chown -R "${USER_NAME}:${USER_NAME}" "${USER_HOME}/Downloads"

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ========== Aur => paru =========="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

PARU_DIR="${USER_REPOS}/paru"
if [[ -d "$PARU_DIR" ]]; then
  echo -e "${GREEN}[!] Directorio '$PARU_DIR' ya existe.${RESET}"
else
  git clone https://aur.archlinux.org/paru.git "$PARU_DIR"
  chown -R "${USER_NAME}:${USER_NAME}" "$PARU_DIR"
  sudo -u "${USER_NAME}" bash -c "cd '$PARU_DIR' && makepkg -si --noconfirm"
fi

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ===== Configuration Mirrors ====="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

sudo -u "${USER_NAME}" bash -c 'paru -S rate-mirrors-bin'
rate-mirrors arch | sudo tee /etc/pacman.d/mirrorlist

sudo -u "${USER_NAME}" bash -c 'paru -S hyprshutdown hyprswitch'

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ===== CachyOS Repos Config ======="
echo -e "${BLUE} =================================="

# 1. Clave GPG (Forzando servidor HTTP vía puerto 80 para evitar bloqueos)
echo "-> Importando y firmando llaves GPG de CachyOS..."
pacman-key --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys F3B607488DB35A47 || true
pacman-key --lsign-key F3B607488DB35A47

# 2. Instalación de paquetes esenciales del repositorio CachyOS
echo "-> Instalando keyring y mirrorlists de CachyOS..."
CACHY_URL="https://mirror.cachyos.org/repo/x86_64/cachyos"

pacman -U --noconfirm \
  "${CACHY_URL}/cachyos-keyring-20240331-1-any.pkg.tar.zst" \
  "${CACHY_URL}/cachyos-mirrorlist-27-1-any.pkg.tar.zst" \
  "${CACHY_URL}/cachyos-v3-mirrorlist-27-1-any.pkg.tar.zst" \
  "${CACHY_URL}/cachyos-v4-mirrorlist-27-1-any.pkg.tar.zst"

# 3. Automatización del script de detección de CPU (v3/v4/znver4)
echo "-> Descargando y aplicando configuración de repositorios CachyOS..."
TMP_CACHYDIR=$(mktemp -d)
curl -sSL https://mirror.cachyos.org/cachyos-repo.tar.xz | tar -xJ -C "$TMP_CACHYDIR"

pushd "${TMP_CACHYDIR}/cachyos-repo" >/dev/null

# Comentamos la línea de descarga remota redundante dentro del script para prevenir fallos
sed -i 's/.*pacman-key --recv-keys/# &/' cachyos-repo.sh 2>/dev/null || true

# Ejecutamos la instalación de los repos
./cachyos-repo.sh --install

popd >/dev/null
rm -rf "$TMP_CACHYDIR"

# 4. Sincronización final de la base de datos de pacman
echo "-> Sincronizando bases de datos..."
pacman -Syu --noconfirm

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ====== Installing Terminal ======"
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm kitty starship zsh nushell

pacman -S --noconfirm zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting
pacman -S --noconfirm lsd bat

chsh -s $(which nu) "$USER_NAME"

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ===== Actualizando el Shell ====="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

ZSH_PATH="$(command -v zsh || true)"

echo "-> Cambiando shell a zsh..."
usermod --shell "$ZSH_PATH" root
usermod --shell "$ZSH_PATH" "$USER_NAME"

echo "%wheel ALL=(ALL) ALL" >/etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel

sudo -u "$USER_NAME" bash -c 'paru -S carapace-bin'
pacman -S --noconfirm bat fzf tree starship
pacman -S --noconfirm sccache

# Node
sudo -u "$USER_NAME" bash -c 'paru -S fnm-bin'
sudo -u "$USER_NAME" bash -c 'export PATH="$HOME/.local/share/fnm:$PATH"; fnm install --latest'

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ======== Essential tools ========"
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm brightnessctl wl-clipboard bottom
pacman -S --noconfirm curl unzip wget lm_sensors pkg-config
# notify
pacman -S --noconfirm libnotify swaync

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} =========== Lenguages ==========="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

LOCALES=("de_DE.UTF-8" "en_US.UTF-8" "es_ES.UTF-8" "ja_JP.UTF-8")

for locale in "${LOCALES[@]}"; do
  sed -i "s/^#\s*${locale} UTF-8/${locale} UTF-8/" /etc/locale.gen
done

locale-gen

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ==== Instalando Login Manager ===="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm greetd greetd-regreet

if id greeter &>/dev/null; then
  echo "✔ El usuario greeter ya existe. Continuando..."
else
  useradd -r -s /usr/bin/nologin -d /var/lib/greetd -M greeter
fi

mkdir -p /var/lib/greetd/.config/hypr
chown -R greeter:greeter /var/lib/greetd

cp -r "${FUIS_REPO}/etc/greetd/." /etc/greetd/

chmod 644 /etc/greetd/config.toml
chmod +x /etc/greetd/start-greeter
systemctl enable greetd

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ============= Fonts ============="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm noto-fonts \
  noto-fonts-cjk \
  noto-fonts-emoji \
  gnu-free-fonts \
  ttf-firacode-nerd \
  ttf-dejavu \
  ttf-liberation

sudo -u "${USER_NAME}" bash -c 'paru -S ttf-sarasa-gothic-nerd-fonts'

fc-cache -fv

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ==== Instaling documentation ===="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm locate man-db

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ====== Instalando el Editor ======"
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm vim neovim
pacman -S --noconfirm wl-clipboard

echo ""
echo -e "${BLUE} =============================="
echo -e "${GREEN} ====== APPS System Core ======"
echo -e "${BLUE} =============================="
echo -e "${RESET}"

# interfaces
sudo -u "${USER_NAME}" bash -c 'paru -S aylurs-gtk-shell'
sudo -u "${USER_NAME}" bash -c 'paru -S libastal-notifd-git libastal-battery-git libastal-mpris-git'
# bar
pacman -S --noconfirm ironbar
# launcher
sudo -u "${USER_NAME}" bash -c 'paru -S anyrun'
# logout
sudo -u "${USER_NAME}" bash -c 'paru -S wlogout'
# monitores
pacman -S --noconfirm wdisplays

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ======= Copiying My Files ======="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

# root
cp -r "${FUIS_REPO}/root/.config/." /root/.config/
cp -r "${FUIS_REPO}/root/.zshrc" /root/

echo ""
echo -e "${BLUE}=================================="
echo -e "${GREEN}============= READY! ============="
echo -e "${BLUE}=================================="
echo -e "${RESET}"
echo ""
echo ""
echo ""
echo ""
