#!/usr/bin/env bash
#
# performance-mode.sh — Toggle a lightweight "gamemode" profile.
#
# ON:
#   - Disables animations, blur, shadows, transparency, rounding and gaps in Hyprland
#   - Makes the terminal fully opaque (kitty via remote control, ghostty via
#     a Hyprland windowrule opacity override, since ghostty has no remote IPC yet)
#   - Fills the wallpaper to black with awww (swww fork) — no image decode while gaming
#   - Pauses cava (SIGSTOP) and syncthing (systemd user unit)
#   - Hides ironbar via IPC (no kill/respawn, no flicker)
# OFF:
#   - Reloads hyprland.conf to restore your normal visual settings
#   - Restores the terminal opacity
#   - Restores the wallpaper with `awww restore`
#   - Resumes cava and syncthing, shows ironbar again
#
# Terminal detection: if the kitty socket exists (kitty running with
# allow_remote_control), kitty is used; otherwise ghostty is assumed.
#
# Requires your ironbar config to set a top-level `name` (this script
# targets "main" — see config.corn).
#
# Requires kitty.conf to have:
#   allow_remote_control yes
#   listen_on unix:/tmp/kitty-hypr
#   dynamic_background_opacity yes
# (listen_on is read at kitty startup: restart kitty once after editing.)
#
# Requires kitty to be launched with --single-instance (or -1) so all
# terminal windows share one socket. Update bindings.lua:
#   local term = "kitty --single-instance"
#
# Wallpaper is handled by awww (drop-in for swww); the daemon is started
# in config/autostart.lua. Change WALLPAPER below to pick your default.
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

# --- Terminal: kitty (remote control) or ghostty (hyprland override) ---
KITTY_SOCKET="unix:/tmp/kitty-hypr"
KITTY_SOCKET_FILE="/tmp/kitty-hypr"
KITTY_OPACITY_NORMAL="0.9" # matches background_opacity in kitty.conf
GHOSTTY_CLASS="com.mitchellh.ghostty"

terminal_is_kitty() {
  [ -S "$KITTY_SOCKET_FILE" ]
}

set_terminal_opaque() {
  if terminal_is_kitty; then
    kitty @ --to "$KITTY_SOCKET" set-background-opacity --all "1.0" >/dev/null 2>&1 || true
  else
    hyprctl keyword windowrule "opacity 1.0 override 1.0 override, class:^($GHOSTTY_CLASS)$" >/dev/null 2>&1 || true
  fi
}

restore_terminal_opacity() {
  if terminal_is_kitty; then
    kitty @ --to "$KITTY_SOCKET" set-background-opacity --all "$KITTY_OPACITY_NORMAL" >/dev/null 2>&1 || true
  else
    hyprctl keyword windowrule "unset, class:^($GHOSTTY_CLASS)$" >/dev/null 2>&1 || true
  fi
}

WALLPAPER="$HOME/Pictures/Wallpaper/dark/wallpaper-4.png"

pause_wallpaper() {
  # if the daemon isn't running the screen is already black; nothing to do
  awww clear 000000 >/dev/null 2>&1 || true
}

resume_wallpaper() {
  if ! awww restore >/dev/null 2>&1; then
    setsid -f awww-daemon >/dev/null 2>&1
    sleep 0.5
    awww img "$WALLPAPER" >/dev/null 2>&1 || true
  fi
}

if [ -f "$STATE_FILE" ]; then
  # --- OFF: restore defaults from hyprland.conf ---
  hyprctl reload >/dev/null 2>&1

  resume_proc cava
  systemctl --user start syncthing >/dev/null 2>&1 || true
  show_ironbar
  restore_terminal_opacity
  resume_wallpaper

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
  set_terminal_opaque
  pause_wallpaper

  touch "$STATE_FILE"
  notify "rgb(f38ba8)" "  Performance Mode ON"
fi
