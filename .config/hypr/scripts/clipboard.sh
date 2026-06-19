#!/bin/bash

PLUGIN="/usr/lib/anyrun/libstdin.so"

selected=$(cliphist list | anyrun --plugins "$PLUGIN")

if [ -n "$selected" ]; then
    echo "$selected" | cliphist decode | wl-copy
fi