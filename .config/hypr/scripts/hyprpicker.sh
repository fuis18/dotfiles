#!/bin/bash

if ! command -v hyprpicker >/dev/null 2>&1; then
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "Hyprpicker" "No está instalado. Instálalo para usar este atajo."
    fi
    exit 1
fi

if hyprpicker -a; then
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "Hyprpicker" "Color copiado al portapapeles"
    fi
fi
