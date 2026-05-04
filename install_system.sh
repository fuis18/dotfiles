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

pacman -Rs rust
pacman -S rustup
sudo -u "${USER_NAME}" bash -c 'rustup default stable'
sudo -u "${USER_NAME}" bash -c 'rustup target list --installed'

echo ""
echo -e "${BLUE} =============================="
echo -e "${GREEN} === APPS System Defatuls ==="
echo -e "${BLUE} =============================="
echo -e "${RESET}"

# file explorer
sudo -u "${USER_NAME}" bash -c 'paru -S spacedrive'
pacman -S --noconfirm yazi
sudo -u "${USER_NAME}" bash -c 'paru -S ripdrag'
# copy history
pacman -S --noconfirm cliphist
# texteditor
pacman -S --noconfirm gnome-text-editor
pacman -S --noconfirm aspell-es aspell-en nuspell
# galeria
sudo -u "$USER_NAME" bash -c 'paru -S oculante'
# wallpaper
sudo -u "$USER_NAME" bash -c 'paru -S swww'
sudo -u "$USER_NAME" bash -c 'paru -S wallust'
# screenshot
pacman -S --noconfirm grim slurp swappy
sudo -u "${USER_NAME}" bash -c 'paru -S grimblast'
# music
sudo -u "$USER_NAME" bash -c 'paru -S musikcube-bin'

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ========== Theme System =========="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

pacman -S --noconfirm papirus-icon-theme
sudo -u "${USER_NAME}" bash -c 'paru -S papirus-folders-catppuccin-git catppuccin-gtk-theme-mocha'

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
sudo -u "$USER_NAME" bash -c 'paru -S cbonsai'
sudo -u "$USER_NAME" bash -c 'paru -S cmatrix-git'

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
echo -e "${BLUE}=================================="
echo -e "${GREEN}============= READY! ============="
echo -e "${BLUE}=================================="
echo -e "${RESET}"
echo ""
echo ""
echo ""
echo ""

sudo bash install_normal.sh
