#!/usr/bin/env zsh
if file --mime "$1" | grep -q binary; then
    echo "$1 es un archivo binario"
else
    bat --style=numbers --color=always "$1" 2>/dev/null || cat "$1"
fi | head -500
