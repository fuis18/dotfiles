#!/usr/bin/env zsh
if file --mime "$1" | grep -q binary; then
    echo "$1 is a binary file"
else
    bat --style=numbers --color=always "$1" 2>/dev/null || cat "$1"
fi | head -500
