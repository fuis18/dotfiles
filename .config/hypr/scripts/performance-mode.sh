#!/usr/bin/env bash
#
# performance-mode.sh — Toggle a lightweight "gamemode" profile.
#
# ON:
#   - Disables animations, blur, shadows, transparency, rounding and gaps in Hyprland
#   - Pauses cava (SIGSTOP) and syncthing (systemd user unit)
#   - Hides ironbar via IPC (no kill/respawn, no flicker)
# OFF:
#   - Reloads hyprland.conf to restore your normal visual settings
#   - Resumes cava and syncthing, shows ironbar again
#
# Requires your ironbar config to set a top-level `name` (this script
# targets "main" — see config.corn).
#
# Bind: SUPER + SHIFT + G
#
# hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd(scriptsDir .. "/performance-mode.sh"))

set -euo pipefail

STATE_DIR="$HOME/.cache/hypr"
STATE_FILE="$STATE_DIR/performance-mode"

mkdir -p "$STATE_DIR"

notify() {
  # icon 1 = info, 3000ms, catppuccin-mocha color
  hyprctl notify 1 3000 "$1" "$2" >/dev/null 2>&1 || true
}

pause_proc() {
  pkill -STOP -x "$1" 2>/dev/null || true
}

resume_proc() {
  pkill -CONT -x "$1" 2>/dev/null || true
}

IRONBAR_NAME="main"

hide_ironbar() {
  ironbar bar set-visibility "$IRONBAR_NAME" false >/dev/null 2>&1 || true
}

show_ironbar() {
  ironbar bar set-visibility "$IRONBAR_NAME" true >/dev/null 2>&1 || true
}

if [ -f "$STATE_FILE" ]; then
  # --- OFF: restore defaults from hyprland.conf ---
  hyprctl reload >/dev/null 2>&1

  resume_proc cava
  systemctl --user start syncthing >/dev/null 2>&1 || true
  show_ironbar

  rm -f "$STATE_FILE"
  notify "rgb(a6e3a1)" "  Performance Mode OFF"
else
  # --- ON: strip visuals + pause background load ---
  hyprctl eval 'hl.config({
    animations = { enabled = false },
    decoration = {
      shadow = { enabled = false },
      blur = { enabled = false },
      rounding = 0,
      active_opacity = 1,
      inactive_opacity = 1,
    },
    general = { gaps_in = 0, gaps_out = 0, border_size = 1 },
  })' >/dev/null 2>&1
  hyprctl eval 'hl.animation({ leaf = "borderangle", enabled = false })' >/dev/null 2>&1

  pause_proc cava
  systemctl --user stop syncthing >/dev/null 2>&1 || true
  hide_ironbar

  touch "$STATE_FILE"
  notify "rgb(f38ba8)" "  Performance Mode ON"
fi
