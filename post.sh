#!/usr/bin/env zsh

# Handle Errors
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Use sudo, need the root"
    exit 1
fi

sudo zsh install/system-2.sh
sudo zsh install/personal-1.sh
sudo zsh install/personal-2.sh
sudo zsh install/normal.sh
