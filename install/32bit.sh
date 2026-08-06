#!/usr/bin/env zsh

# Manejo de errores
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Use sudo, need the root"
  exit 1
fi

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ========= libs for Steam ========="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

sudo pacman -S steam
sudo pacman -S lib32-openal \
  lib32-libxrandr lib32-libxcursor \ 
  lib32-libxi lib32-pipewire
