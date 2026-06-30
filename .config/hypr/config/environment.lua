hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("WEBRTC_ENABLE_HW_ENCODING", "1")
hl.env("WEBRTC_ENABLE_HW_DECODING", "1")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")

hl.env("XKB_DEFAULT_LAYOUT", "latam")
hl.env("XMODIFIERS", "@im=fcitx5")

hl.env("GTK_THEME", "catppuccin-mocha-blue-standard+default")
hl.env("GTK_ICON_THEME", "Papirus-Dark")
hl.env("GTK_APPLICATION_PREFER_DARK_THEME", "1")

hl.env("GRIMBLAST_SCREENSHOTS_DIR", os.getenv("HOME") .. "/Pictures/Screenshots")
