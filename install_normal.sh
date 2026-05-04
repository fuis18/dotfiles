#!/bin/bash

# Manejo de errores
set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

echo ""
echo -e "${BLUE} =================================="
echo -e "${GREEN} ========== Theme System =========="
echo -e "${BLUE} =================================="
echo -e "${RESET}"

papirus-folders -C cat-mocha-blue --theme Papirus-Dark
