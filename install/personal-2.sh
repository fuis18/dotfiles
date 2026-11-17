#!/usr/bin/env zsh

# Manejo de errores
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Use sudo, need the root"
    exit 1
fi

USER_NAME=${SUDO_USER:-$(whoami)}
USER_HOME="/home/${USER_NAME}"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ========== Programaing =========="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

pacman -S --noconfirm deno go bacon
# pacman -S --noconfirm github-cli
sudo -u "$USER_NAME" bash -c 'paru -S jujutsu lazyjj'
pacman -S --noconfirm lazygit
pacman -S --noconfirm hurl
sudo -u "$USER_NAME" bash -c 'paru -S xh'

pacman -S podman podman-compose
# sudo -u "$USER_NAME" bash -c 'paru -S oxker-bin lazydocker'

# editors
pacman -S --noconfirm zed

echo ""
echo -e "${BLUE} ================================"
echo -e "${GREEN} =========== Browsers ==========="
echo -e "${BLUE} ================================"
echo -e "${RESET}"

# Diary
pacman -S epiphany
sudo -u "$USER_NAME" bash -c 'paru -S helium-browser-bin'
sudo -u "$USER_NAME" bash -c 'paru -S zen-browser-bin'
sudo -u "$USER_NAME" bash -c 'paru -S brave-bin'

# Privacity
sudo -u "$USER_NAME" bash -c 'paru -S mullvad-browser-bin'
pacman -S --noconfirm torbrowser-launcher

echo ""
echo -e "${BLUE} ================================"
echo -e "${GREEN} ========== Pentesting =========="
echo -e "${BLUE} ================================"
echo -e "${RESET}"

pacman -S --noconfirm nmap

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ============= APPS ============="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm musescore

pacman -S --noconfirm kseexpr
pacman -S --noconfirm blender gimp krita

# android tool
pacman -S --noconfirm android-tools scrcpy

# pacman -S --noconfirm texlive-basic texlive-latex pandoc-cli

# games
# pacman -S lutris
# sudo -u "$USER_NAME" bash -c 'paru -S pcsx2-latest-bin'
# sudo -u "$USER_NAME" bash -c 'paru -S rpcs3-bin'

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ======== READY Personal 2 ========"
echo -e "${BLUE} =================================="
echo -e "${RESET}"
echo ""
echo ""
echo ""
