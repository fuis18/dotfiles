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

pacman -S --needed --noconfirm base-devel \
  devtools \
  wayland \
  xdg-desktop-portal \
  xdg-desktop-portal-gtk

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ========= Hyprland Shell ========="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --needed --noconfirm hyprland \
  hyprlock \
  hypridle \
  hyprpolkitagent \
  xdg-desktop-portal-hyprland

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ============== Core =============="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --needed --noconfirm wget openssh openssl \
  gtk4 gtk4-layer-shell pkg-config \
  qt6ct qt6-base qt6-declarative qt6-wayland qt5-wayland \
  upower gnome-keyring xsettingsd

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ============ Drivers ============"
echo -e "${BLUE} ================================="
echo -e "${RESET}"
echo ""

pacman -S --needed --noconfirm libva v4l2loopback-dkms

# Intel
pacman -S --needed --noconfirm libva-intel-driver intel-media-driver
# AMD
pacman -S --needed --noconfirm mesa libva-mesa-driver libvdpau-va-gl mesa-utils
# vulkan-radeon lib32-vulkan-radeon
# NVidia
# pacman -S --noconfirm nvidia-utils libva-vdpau-driver

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ===== Network Configuration ====="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --needed --noconfirm bluez bluez-utils dbus

systemctl enable bluetooth
systemctl start bluetooth

pacman -S --needed --noconfirm impala bluetui

# Segurity

pacman -S --needed --noconfirm ufw

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
sudo -u "${USER_NAME}" bash -c 'rate-mirrors arch | sudo tee /etc/pacman.d/mirrorlist'

sudo -u "${USER_NAME}" bash -c 'paru -S hyprshutdown hyprswitch'

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ====== Installing Terminal ======"
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --needed --noconfirm kitty starship zsh nushell \
  zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting

sudo -u "$USER_NAME" bash -c 'paru -S carapace-bin'

echo ""
echo -e "${BLUE} ================================"
echo -e "${GREEN} ======== Terminal Tools ========"
echo -e "${BLUE} ================================"
echo -e "${RESET}"

pacman -S --needed --noconfirm lsd bat \
  fzf tree sccache \
  jq poppler fd ripgrep \
  zoxide resvg imagemagick \
  yazi

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

# Node
sudo -u "$USER_NAME" bash -c 'paru -S fnm-bin'
sudo -u "$USER_NAME" bash -c 'export PATH="$HOME/.local/share/fnm:$PATH"; fnm install --latest'

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ======== Essential tools ========"
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --needed --noconfirm brightnessctl \
  wl-clipboard \
  curl unzip wget \
  lm_sensors pkg-config \
  bottom btop htop
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

pacman -S --needed --noconfirm noto-fonts \
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
