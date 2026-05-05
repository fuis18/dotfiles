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
echo -e "${GREEN} ===== Installing Base System ====="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm base-devel wayland hyprland hyprlock hypridle hyprpolkitagent
pacman -S --noconfirm xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ============== Core =============="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm gtk4 gtk4-layer-shell pkg-config
pacman -S --noconfirm wget openssh openssl
pacman -S --noconfirm qt6-base qt6-declarative qt6-wayland qt5-wayland
pacman -S --noconfirm upower gnome-keyring xsettingsd

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
pacman -S --noconfirm mesa libva-mesa-driver libvdpau-va-gl mesa-utils vulkan-radeon lib32-vulkan-radeon
# NVidia
pacman -S --noconfirm nvidia-utils libva-vdpau-driver

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
echo -e "${BLUE} =================================="
echo -e "${GREEN} ========= Main Dev Tools ========="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

sudo -u "$USER_NAME" bash -c 'paru -S fnm-bin'
sudo -u "$USER_NAME" bash -c 'fnm install --latest'

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ====== Installing Terminal ======"
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm kitty zsh starship
pacman -S --noconfirm zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting
pacman -S --noconfirm bat lsd fzf tree
pacman -S --noconfirm sccache

echo ""
echo -e "${BLUE} ================================"
echo -e "${GREEN} === Configurando el terminal ==="
echo -e "${BLUE} ================================"
echo -e "${RESET}"

PLUGIN_DIR="/usr/share/zsh-sudo"

mkdir -p "${PLUGIN_DIR}"
chown -R "${USER_NAME}:${USER_NAME}" "${PLUGIN_DIR}"
sudo -u "${USER_NAME}" wget -qO "${PLUGIN_DIR}/sudo.plugin.zsh" \
  https://raw.githubusercontent.com/hcgraf/zsh-sudo/master/sudo.plugin.zsh

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
echo -e "${BLUE} ================================="
echo -e "${GREEN} ===== Network Configuration ====="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm wpa_supplicant bluez bluez-utils dbus

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl start bluetooth

pacman -S --noconfirm impala bluetui

# Segurity

pacman -S --noconfirm ufw

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ==== Instalando Login Manager ===="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm greetd greetd-tuigreet

if id greeter &>/dev/null; then
    echo "✔ El usuario greeter ya existe. Continuando..."
else
    useradd -r -s /usr/bin/nologin -d /var/lib/greetd -M greeter
fi

cp -r "${FUIS_REPO}/etc/greetd/." /etc/greetd/

chmod 644 /etc/greetd/config.toml
systemctl enable greetd

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
echo -e "${GREEN} ===== Actualizando el Shell ====="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

ZSH_PATH="$(command -v zsh || true)"

echo "-> Cambiando shell a zsh..."
usermod --shell "$ZSH_PATH" root
usermod --shell "$ZSH_PATH" "$USER_NAME"

echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ==== Instaling documentation ===="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm locate man-db

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ==== Multimedia applications ===="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

# 1. PipeWire: El motor de audio y video unificado
pacman -S --noconfirm pipewire \
	pipewire-pulse \
	pipewire-alsa \
	pipewire-jack \
	wireplumber \
	pavucontrol \
	pulsemixer

# 2. Codecs: Los motores esenciales para video/audio
sudo pacman -S --noconfirm \
  ffmpeg \
	ffmpegthumbs \
	taglib \
	gst-libav \
  gst-plugins-good \
  gst-plugins-bad \
  gst-plugins-ugly

# 3. Reproducción: Máxima potencia, mínima RAM
pacman -S --noconfirm \
  mpv \
  cava \
  yt-dlp

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ====== Instalando el Editor ======"
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm vim neovim
pacman -S --noconfirm wl-clipboard

echo ""
echo -e "${BLUE} =============================="
echo -e "${GREEN} === APPS System Defatuls ==="
echo -e "${BLUE} =============================="
echo -e "${RESET}"

# taskbar
pacman -S ironbar
# Sistema de apagado
sudo -u "${USER_NAME}" bash -c 'paru -S hyprshutdown'
# launcher
sudo -u "${USER_NAME}" bash -c 'paru -S anyrun'
# window switcher
sudo -u "${USER_NAME}" bash -c 'paru -S hyprswitch'
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
cp -r "${FUIS_REPO}/root/config/." /root/.config/
cp -r "${FUIS_REPO}/root/zshrc" /root/
mv /root/zshrc /root/.zshrc

echo ""
echo -e "${BLUE}=================================="
echo -e "${GREEN}============= READY! ============="
echo -e "${BLUE}=================================="
echo -e "${RESET}"
echo ""
echo ""
echo ""
echo ""

sudo bash "${FUIS_REPO}/update_system.sh"
