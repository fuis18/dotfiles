#!/bin/bash

# 1. Lista de aplicaciones que queremos cerrar bien
# Puedes añadir más como 'steam', 'discord', etc.
apps=("chrome" "librewolf" "brave")

for app in "${apps[@]}"; do
    if pgrep -x "$app" > /dev/null; then
        # Enviamos SIGTERM (solicitud de cierre amable)
        pkill -15 -x "$app"
    fi
done

# 2. Esperar un poco a que guarden datos (ajusta los segundos según tu PC)
sleep 2

# 3. Cerrar la sesión de Hyprland limpiamente
# Esto ayuda a que el compositor suelte los recursos
hyprctl dispatch exit 1

# 4. Finalmente, ejecutar el comando del sistema
if [ "$1" == "reboot" ]; then
    systemctl reboot
else
    systemctl poweroff
fi
