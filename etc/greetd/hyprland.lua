hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = 1,
})

hl.config({
    input = {
        kb_layout = "latam",
        follow_mouse = 2,
    },
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 0,
        resize_on_border = false,
        hover_icon_on_border = false,
        no_focus_fallback = true,
        layout = "master",
        allow_tearing = false,
    },
    decoration = {
        rounding = 0,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        fullscreen_opacity = 1.0,
        dim_inactive = false,
        shadow = { enabled = false },
        blur = { enabled = false },
    },
    animations = { enabled = false },
    misc = {
        disable_autoreload = true,
        disable_hyprland_logo = true,
    },
})

hl.on("hyprland.start", function()
    hl.exec_cmd("regreet")
    hl.exec_cmd("hyprctl dispatch exit")
end)
