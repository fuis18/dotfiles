#!/usr/bin/env bash
# Fuerza el keymap de XWayland para apps X11 (Steam, etc.)
# Bug conocido: Hyprland arranca XWayland con "us" (hyprwm/Hyprland#8481).
# Re-afirma el layout durante unos minutos para sobrevivir a re-syncs.

layout="${1:-latam}"
model="${2:-pc105}"
log="$HOME/.config/hypr/scripts/xwayland-keymap.log"

log() { printf '%s %s\n' "$(date +%T)" "$*" >>"$log"; }

# Detectar el display de XWayland (el entorno de exec_cmd puede no tener DISPLAY)
if [ -z "$DISPLAY" ] || ! setxkbmap -query >/dev/null 2>&1; then
  for sock in /tmp/.X11-unix/X*; do
    [ -e "$sock" ] || continue
    d="${sock##*/X}"
    if DISPLAY=":$d" setxkbmap -query >/dev/null 2>&1; then
      export DISPLAY=":$d"
      break
    fi
  done
fi

log "start (DISPLAY=${DISPLAY:-none} layout=$layout)"

# Esperar a que XWayland esté disponible
for _ in $(seq 1 60); do
  setxkbmap -query >/dev/null 2>&1 && break
  sleep 0.5
done

# Re-afirmar el layout cada pocos segundos durante ~5 min
(
  for _ in $(seq 1 100); do
    current=$(setxkbmap -query 2>/dev/null | awk '/^layout/{print $2}')
    if [ "$current" != "$layout" ]; then
      setxkbmap -layout "$layout" -model "$model" 2>/dev/null
      log "keymap $current -> $layout"
    fi
    sleep 3
  done
  log "done"
) >/dev/null 2>&1 &
