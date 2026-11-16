#!/bin/bash

# Handle Errors
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Use sudo, need the root"
  exit 1
fi

sudo bash ./install/core.sh
sudo bash ./install/system.sh
sudo bash ./install/update.sh
