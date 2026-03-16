#!/bin/bash

# Manejo de errores
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Use sudo, need the root"
    exit 1
fi

USER_NAME=${SUDO_USER:-$(whoami)}
USER_HOME="/home/${USER_NAME}"
USER_REPOS="${USER_HOME}/Downloads/repos"
FUIS_REPO="${USER_REPOS}/fuis18/dotfiles"
PACMAN_CONF="/etc/pacman.conf"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

# NEW_CMD='XferCommand = /usr/bin/curl -L -C - --retry 10 --retry-delay 5 --connect-timeout 30 --max-time 0 -o %o %u'

# Reemplazar si existe (comentado o no)
# if grep -qE '^[# ]*XferCommand\s*=' "$PACMAN_CONF"; then
#     sudo sed -i "s|^[# ]*XferCommand\s*=.*|$NEW_CMD|" "$PACMAN_CONF"
# else
#     # Agregar bajo [options]
#     sudo sed -i "/^\[options\]/a $NEW_CMD" "$PACMAN_CONF"
# fi


echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ====== Updating the System ======="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

# pacman -Syu --noconfirm

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ===== Installing Base System ====="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm wayland hyprland hyprlock hypridle
pacman -S --noconfirm qt6-base qt6-declarative qt6-quick3d qt6-graphs

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
  git clone https://aur.archlinux.org/yay.git "$YAY_DIR"
  chown -R "${USER_NAME}:${USER_NAME}" "$YAY_DIR"
  sudo -u "${USER_NAME}" bash -c "cd '$YAY_DIR' && makepkg -si --noconfirm"
fi

echo ""
echo -e "${BLUE} ==============================="
echo -e "${GREEN} ====== System Defatuls ======"
echo -e "${BLUE} ==============================="
echo -e "${RESET}"

pacman -S --noconfirm xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
pacman -S --noconfirm papirus-icon-theme

sudo -u fuis18 bash -c 'paru -S wlogout yofi-bin'
sudo -u fuis18 bash -c 'paru -S ironbar-bin scrub'

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ====== Installing Terminal ======"
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm kitty zsh starship zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting

pacman -S --noconfirm bat lsd fzf gnu-free-fonts

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} === Instalando el documentador ==="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm locate man-db

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ======== Essential tools ========"
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm brightnessctl wl-clipboard btop swaync libnotify
pacman -S --noconfirm curl unzip wget lm_sensors
pacman -S --noconfirm yazi

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} =========== Lenguages ==========="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

LOCALES=("de_DE.UTF-8" "en_US.UTF-8" "es_ES.UTF-8" "ja_JP.UTF-8")

for locale in "${LOCALES[@]}"; do
    sed -i "s/^# ${locale} UTF-8/${locale} UTF-8/" /etc/locale.gen
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

sudo -u fuis18 bash -c 'paru -S bluetui'

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ====== Captura de Pantalla ======"
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm grim slurp swappy

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

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ====== Copiying Root Files ======"
echo -e "${BLUE} ================================="
echo -e "${RESET}"

cp -r "${FUIS_REPO}/root/config/." /root/.config/

cp -r "${FUIS_REPO}/root/zshrc" /root/
# Renombrar
mv /root/zshrc /root/.zshrc

echo -e "${BLUE} ================================="
echo -e "${GREEN} ============= Fonts ============="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

paru -S nerd-fonts-fira-code

pacman -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-dejavu ttf-liberation

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
echo -e "${GREEN} ======= Copiying My Files ======="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

cp -r "${FUIS_REPO}/config/." "${USER_HOME}/.config/"
chown -R "${USER_NAME}:${USER_NAME}" "${USER_HOME}/.config"

cp -r "${FUIS_REPO}/zshrc" "${USER_HOME}/"
mv "${USER_HOME}/zshrc" "${USER_HOME}/.zshrc"
chown "${USER_NAME}:${USER_NAME}" "${USER_HOME}/.zshrc"

find "${USER_HOME}/.config/hypr/scripts/" -type f -name "*.sh" -exec chmod +x {} \;

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
