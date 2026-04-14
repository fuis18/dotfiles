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

pacman -S --noconfirm base-devel wayland hyprland hyprlock hypridle wget

pacman -S --noconfirm xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
pacman -S --noconfirm qt6-base qt6-declarative

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
echo -e "${GREEN} =========== Aur => yay ==========="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

YAY_DIR="${USER_REPOS}/yay"
if [[ -d "$YAY_DIR" ]]; then
  echo -e "${GREEN}[!] Directorio '$YAY_DIR' ya existe.${RESET}"
  else
  git clone https://aur.archlinux.org/yay-bin.git "$YAY_DIR"
  chown -R "${USER_NAME}:${USER_NAME}" "$YAY_DIR"
  sudo -u "${USER_NAME}" bash -c "cd '$YAY_DIR' && makepkg -si --noconfirm"
fi

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ====== Installing Terminal ======"
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm kitty zsh starship zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting
pacman -S --noconfirm bat lsd fzf

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

pacman -S --noconfirm brightnessctl wl-clipboard btop
pacman -S --noconfirm curl unzip wget lm_sensors
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
pacman -S --noconfirm ufw

systemctl enable NetworkManager
systemctl enable wpa_supplicant
systemctl start wpa_supplicant
systemctl enable bluetooth
systemctl start bluetooth

pacman -S bluetui

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

pacman -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-emoji gnu-free-fonts
pacman -S --noconfirm ttf-firacode-nerd ttf-dejavu ttf-liberation
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

# audio
pacman -S --noconfirm pipewire pipewire-pulse wireplumber
pacman -S --noconfirm pipewire-alsa alsa-utils
# codecs
pacman -S --noconfirm gst-libav gst-plugins-good gst-plugins-bad gst-plugins-ugly
# video
pacman -S --noconfirm mpv
# musica
pacman -S --noconfirm mpd mpc
pacman -S --noconfirm fftw ncmpcpp cava
# controls
pacman -S --noconfirm pulsemixer

pacman -S cliphist

echo ""
echo -e "${BLUE} =============================="
echo -e "${GREEN} === APPS System Defatuls ==="
echo -e "${BLUE} =============================="
echo -e "${RESET}"

pacman -S hyprpolkitagent
sudo -u "${USER_NAME}" bash -c 'paru -S hyprshutdown'
# launcher
sudo -u "${USER_NAME}" bash -c 'paru -S anyrun'
# taskbar
pacman -S ironbar
# window switcher
sudo -u "${USER_NAME}" bash -c 'paru -S hyprswitch'
# file explorer
sudo -u "${USER_NAME}" bash -c 'paru -S spacedrive-bin'
pacman -S --noconfirm yazi
sudo -u "${USER_NAME}" bash -c 'paru -S ripdrag-bin'
# logout
sudo -u "${USER_NAME}" bash -c 'paru -S wlogout'
# copy history
pacman -S cliphist
# galeria
sudo -u "$USER_NAME" bash -c 'paru -S oculante'
# screeshot
pacman -S --noconfirm grim slurp swappy
sudo -u "${USER_NAME}" bash -c 'paru -S grimblast-git'

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ==== Creating the directories ===="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

sudo -u "$USER_NAME" mkdir -p "$USER_HOME/Documents/Organizer"
sudo -u "$USER_NAME" mkdir -p "$USER_HOME/Music"
sudo -u "$USER_NAME" mkdir -p "$USER_HOME/Pictures/Wallpaper"
sudo -u "$USER_NAME" mkdir -p "$USER_HOME/Videos"

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ======= Copiying My Files ======="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

# root
cp -r "${FUIS_REPO}/root/config/." /root/.config/
cp -r "${FUIS_REPO}/root/zshrc" /root/
mv /root/zshrc /root/.zshrc

# .config
sudo -u "$USER_NAME" cp -r "${FUIS_REPO}/config/." "${USER_HOME}/.config/"

sudo -u "$USER_NAME" cp -r "${FUIS_REPO}/zshrc" "${USER_HOME}/"
mv "${USER_HOME}/zshrc" "${USER_HOME}/.zshrc"

find "${USER_HOME}/.config/hypr/scripts/" -type f -name "*.sh" -exec chmod +x {} \;

sudo -u "$USER_NAME" mkdir -p "$USER_HOME/.config/mpd/playlists"

echo ""
echo -e "${BLUE}=================================="
echo -e "${GREEN}============= READY! ============="
echo -e "${BLUE}=================================="
echo -e "${RESET}"
echo ""
echo ""
echo ""
echo ""
reboot
