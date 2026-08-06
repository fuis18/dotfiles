#!/usr/bin/env zsh

# Handle Errors
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Use sudo, need the root"
    exit 1
fi

USER_NAME=$(logname)
USER_HOME="/home/${USER_NAME}"
DOTFILES="${USER_HOME}/dotfiles"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

echo ""
echo -e "${BLUE} ================================="
echo -e "${GREEN} ======= Copiying My Files ======="
echo -e "${BLUE} ================================="
echo -e "${RESET}"

# .config
sudo -u "$USER_NAME" cp -r "${DOTFILES}/.config/." "${USER_HOME}/.config/"
sudo -u "$USER_NAME" cp -r "${DOTFILES}/.local/bin/." "${USER_HOME}/.local/bin/"
sudo -u "$USER_NAME" cp -r "${DOTFILES}/.zshrc" "${USER_HOME}/.zshrc"

sudo -u "$USER_NAME" ya pack -a

find "${USER_HOME}/.config/hypr/scripts/" -type f -name "*.sh" -exec chmod +x {} \;
