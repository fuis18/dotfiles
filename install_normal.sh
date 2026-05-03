#!/bin/bash

# Manejo de errores
set -euo pipefail

USER_NAME=${SUDO_USER:-$(whoami)}
USER_HOME="/home/${USER_NAME}"

if systemctl --user status >/dev/null 2>&1; then
  systemctl --user enable syncthing.service
  systemctl --user start syncthing.service
fi

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ========== Theme System =========="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

papirus-folders -C cat-mocha-blue --theme Papirus-Dark
