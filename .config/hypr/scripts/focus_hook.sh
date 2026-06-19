# ~/.config/hypr/scripts/focus_hook.sh
#!/usr/bin/env bash

hyprctl events -j | while read -r event; do
    # Solo reaccionar si es cambio de ventana enfocada
    echo "$event" | jq -e 'select(.type=="focus")' >/dev/null || continue

    # Leer ventana activa
    window=$(hyprctl activewindow -j)
    title=$(echo "$window" | jq -r '.title')
    pid=$(echo "$window" | jq -r '.pid')

    # Reemplazo de caracteres problemáticos
    safe_title=$(echo "$title" \
        | sed 's/á/a/g' \
        | sed 's/é/e/g' \
        | sed 's/í/i/g' \
        | sed 's/ó/o/g' \
        | sed 's/ú/u/g' \
        | sed 's/Á/A/g' \
        | sed 's/É/E/g' \
        | sed 's/Í/I/g' \
        | sed 's/Ó/O/g' \
        | sed 's/Ú/U/g' \
        | sed 's/ñ/n/g' \
        | sed 's/Ñ/N/g' \
        | sed 's/ü/u/g' \
        | sed 's/Ü/U/g')

    # Renombrar la ventana
    hyprctl dispatch renamewindow "$pid" "$safe_title"
done
