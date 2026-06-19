#!/bin/bash

shots_dir="${GRIMBLAST_SCREENSHOTS_DIR:-$HOME/Pictures/Screenshots}"
mkdir -p "$shots_dir"

timestamp="$(date +'%Y-%m-%d_%H-%M-%S')"
shot_file="$shots_dir/Screenshot_${timestamp}.png"

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$@"
    fi
}

open_oculante() {
    if command -v oculante >/dev/null 2>&1; then
        oculante "$1" >/dev/null 2>&1 &
    else
        notify "Captura guardada" "$1"
    fi
}

clipboard_has_image() {
    wl-paste --list-types 2>/dev/null | grep -Eq '^image/'
}

clipboard_to_file() {
    local dest="$1"
    wl-paste --type image/png > "$dest" 2>/dev/null && return 0
    wl-paste --type image/jpeg > "$dest" 2>/dev/null && return 0
    wl-paste --type image/webp > "$dest" 2>/dev/null && return 0
    return 1
}

case "${1:-}" in
    copy-screen)
        grimblast --notify copy screen
        ;;
    save-screen)
        grimblast --notify save screen "$shot_file"
        ;;
    save-area)
        grimblast --notify save area "$shot_file"
        ;;
    copy-area)
        grimblast copy area
        ;;
    view-area)
        if grimblast copysave area "$shot_file"; then
            open_oculante "$shot_file"
            notify "Captura de área" "Abierta en oculante"
        fi
        ;;
    view-screen)
        if grimblast --notify copysave screen "$shot_file"; then
            open_oculante "$shot_file"
        fi
        ;;
    pickup)
        if ! command -v hyprpicker >/dev/null 2>&1; then
            notify "Hyprpicker" "No está instalado. Instálalo para usar pickup."
            exit 1
        fi

        if hyprpicker -a; then
            notify "Hyprpicker" "Color copiado al portapapeles"
        fi
        ;;
    clipboard-view)
        clip_file="$shots_dir/Clipboard_${timestamp}.png"
        if clipboard_has_image && clipboard_to_file "$clip_file" && [ -s "$clip_file" ]; then
            open_oculante "$clip_file"
            notify "Portapapeles" "Imagen abierta en oculante"
        else
            rm -f "$clip_file"
            notify "Portapapeles" "No hay imagen copiada"
            exit 1
        fi
        ;;
    *)
        notify "screenshot.sh" "Uso: copy-screen|save-screen|save-area|copy-area|view-area|view-screen|pickup|clipboard-view"
        exit 1
        ;;
esac
