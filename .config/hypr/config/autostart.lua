local scriptsDir = os.getenv("HOME") .. "/.config/hypr/scripts"

hl.on("hyprland.start", function()
	-- 1. PRIMERO: Registrar el entorno en DBus/Systemd (Crucial para Portales y Qt)
	local envVars =
		"WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP GTK_THEME GTK_ICON_THEME GTK_APPLICATION_PREFER_DARK_THEME QT_QPA_PLATFORM QT_QPA_PLATFORMTHEME QT_AUTO_SCREEN_SCALE_FACTOR GDK_BACKEND MOZ_ENABLE_WAYLAND SDL_VIDEODRIVER XMODIFIERS XKB_DEFAULT_LAYOUT"
	hl.exec_cmd("dbus-update-activation-environment --systemd " .. envVars)
	hl.exec_cmd("systemctl --user import-environment " .. envVars)

	-- 2. SEGUNDO: Configurar los temas GTK/GNOME
	hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-mocha-blue-standard+default'")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-application-prefer-dark-theme true")

	-- legacy support
	hl.exec_cmd("xsettingsd")

	-- 3. TERCERO: Iniciar el resto de tus servicios y barras de estado
	hl.exec_cmd("anyrun daemon")
	hl.exec_cmd("hyprshell run &")
	-- wallpaper: awww daemon + imagen (ajusta la ruta a tu gusto)
	hl.exec_cmd(
		"(awww-daemon &) ; sleep 0.5 ; awww img " .. os.getenv("HOME") .. "/Pictures/Wallpaper/dark/wallpaper-4.png"
	)
	hl.exec_cmd("swaync")
	hl.exec_cmd("ironbar")
	hl.exec_cmd("systemctl --user restart pipewire wireplumber")
	hl.exec_cmd("fcitx5 -d")
	hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("systemctl --user start syncthing")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("hypridle")

	hl.exec_cmd(scriptsDir .. "/focus_hook.sh")
	hl.exec_cmd(scriptsDir .. "/xwayland-keymap.sh")
end)
