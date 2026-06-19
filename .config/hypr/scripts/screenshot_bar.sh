#!/bin/bash

bar_app="$HOME/.config/ags/screenshot-bar.tsx"

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$@"
    fi
}

if ! command -v ags >/dev/null 2>&1; then
    notify "Barra de capturas" "AGS/Astal no está instalado. Instala 'ags' para usar esta barra."
    exit 1
fi

if pgrep -f "ags run $bar_app" >/dev/null 2>&1; then
    ags request show >/dev/null 2>&1 || ags toggle ScreenshotBar >/dev/null 2>&1
    exit 0
fi

ags run "$bar_app" >/tmp/ags-screenshot-bar.log 2>&1 &
disown
sleep 0.2
ags request show >/dev/null 2>&1 || true
