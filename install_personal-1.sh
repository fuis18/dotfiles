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
echo -e "${BLUE} =================================="
echo -e "${GREEN} ====== Updating the System ======="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -Syu

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ======== Logo Arch Linux ========"
echo -e "${BLUE}         .         "
echo -e "               / \\       "
echo -e "              /   \\      "
echo -e "             /\    \\     "
echo -e "            /  \    \\    "
echo -e "           /         \\   "
echo -e "          /    .-.    \\  "
echo -e "         /    |   |   _\\ "
echo -e "        /   _.'   '._   \\"
echo -e "       /_.-'         '-._\\"
echo -e "${RESET}"

pacman -S --noconfirm fastfetch
sudo -u "$USER_NAME" bash -c 'paru -S cbonsai-bin'

sudo -u "$USER_NAME" bash -c 'paru -S cmatrix-git'

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ====== Instalando el Editor ======"
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm vim neovim

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ========== Applications =========="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

# browsers
sudo -u "$USER_NAME" bash -c 'paru -S brave-bin'
sudo -u "$USER_NAME" bash -c 'paru -S google-chrome'
sudo -u "$USER_NAME" bash -c 'paru -S librewolf-bin'

# notas
sudo -u "$USER_NAME" bash -c 'paru -S obsidian-bin'

# ofimatica
sudo -u "$USER_NAME" bash -c 'paru -S onlyoffice-bin'
pacman -S --noconfirm libreoffice-fresh

# Redes
sudo -u "$USER_NAME" bash -c 'paru -S zoom'
pacman -S --noconfirm discord

# Edition
pacman -S --noconfirm kdenlive
pacman -S --noconfirm inkscape

# conexions
pacman -S --noconfirm kdeconnect
pacman -S --noconfirm syncthing

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ============ Keyboard ==========="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm fcitx5 fcitx5-mozc fcitx5-configtool
pacman -S --noconfirm fcitx5-gtk fcitx5-qt

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ======== READY Personal 1 ========"
echo -e "${BLUE} =================================="
echo -e "${RESET}"
echo ""
echo ""
echo ""
