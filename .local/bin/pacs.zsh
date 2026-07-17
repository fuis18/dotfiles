#!/usr/bin/env zsh
pacman -Slq | fzf -m --preview 'pacman -Si {} ; pacman -Fl {} | awk "{print \$2}"' | xargs -ro sudo pacman -S
