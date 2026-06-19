hl.window_rule({
    name = "center-floats",
    match = { float = true },
    center = true,
})

hl.window_rule({
    name = "float-swappy",
    match = { class = "swappy" },
    float = true,
    size = { 900, 600 },
    center = true,
})

hl.window_rule({
    name = "float-oculante",
    match = { class = "oculante" },
    float = true,
    size = { 1100, 700 },
    center = true,
})

hl.window_rule({
    name = "float-zoom-main",
    match = { class = "zoom", title = "Zoom" },
    float = true,
    size = { 860, 580 },
    center = true,
})

hl.window_rule({
    name = "float-zoom-sub",
    match = { class = "zoom" },
    float = true,
    size = { 700, 500 },
    center = true,
})

hl.window_rule({
    name = "float-modals",
    match = { modal = true },
    float = true,
    center = true,
})
