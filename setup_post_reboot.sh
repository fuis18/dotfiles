#!/bin/bash

# Handle Errors
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Use sudo, need the root"
    exit 1
fi

sudo bash install_system.sh
sudo bash install_personal-1.sh
sudo bash install_personal-2.sh
sudo bash install_normal.sh
