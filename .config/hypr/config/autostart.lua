local scriptsDir = os.getenv("HOME") .. "/.config/hypr/scripts"

hl.on("hyprland.start", function()
	-- 1. PRIMERO: Registrar el entorno en DBus/Systemd (Crucial para Portales y Qt)
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland")
	hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

	-- 2. SEGUNDO: Configurar los temas GTK/GNOME
	hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'catppuccin-mocha-blue-standard+default'")
	hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'default-dark'")

	-- legacy support
	hl.exec_cmd("xsettingsd")

	-- 3. TERCERO: Iniciar el resto de tus servicios y barras de estado
	hl.exec_cmd("anyrun daemon")
	hl.exec_cmd("hyprpaper")
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
end)
