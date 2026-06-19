hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 10,
        border_size = 0,
        resize_on_border = true,
        layout = "master",
        snap = {
            enabled = true,
        },
    },

    decoration = {
        rounding = 20,
        active_opacity = 1.0,
        inactive_opacity = 0.9,
        fullscreen_opacity = 1.0,
        dim_inactive = true,
        dim_strength = 0.1,
        dim_special = 0.8,
        shadow = {
            enabled = false,
            range = 3,
            render_power = 1,
            color = "rgba(73c291ff)",
            color_inactive = "rgba(717b8aff)",
        },
        blur = {
            enabled = true,
            size = 6,
            passes = 2,
            ignore_opacity = true,
            new_optimizations = true,
            special = true,
            popups = true,
        },
    },

    group = {
        col = {
            border_active = "rgba(d2d6dcff)",
        },
        groupbar = {
            col = {
                active = "rgba(393a3bff)",
            },
        },
    },

    input = {
        kb_layout = "latam",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        numlock_by_default = true,
        follow_mouse = 2,
        touchpad = {
            natural_scroll = true,
        },
        sensitivity = 0,
    },
})
