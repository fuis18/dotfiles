#!/bin/bash

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

sudo -u "$USER_NAME" bash -c 'paru -S fnm-bin'

pacman -S --noconfirm github-cli
pacman -S --noconfirm lazygit

pacman -S --noconfirm docker docker-compose docker-buildx

sudo -u "$USER_NAME" bash -c 'paru -S oxker-bin'

systemctl enable docker.socket
systemctl start docker.socket

sudo usermod -aG docker $USER_NAME

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ============= APPS ============="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm muse # musescore

pacman -S --noconfirm blender
pacman -S --noconfirm gimp krita
pacman -S --noconfirm obs-studio

pacman -S --noconfirm texlive-full pandoc

pacman -S --noconfirm rclone

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ======== READY Personal 2 ========"
echo -e "${BLUE} =================================="
echo -e "${RESET}"
echo ""
echo ""
echo ""