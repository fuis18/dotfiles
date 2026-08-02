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
	name = "float-zoom-meeting",
	match = { class = "zoom", title = "Zoom Meeting" },
	float = true,
	center = true,
})

hl.window_rule({
	name = "float-zoom-main",
	match = { class = "zoom", title = "Zoom" },
	float = true,
	center = true,
})

hl.window_rule({
	name = "float-zoom-other",
	match = { class = "zoom" },
	float = true,
	center = true,
})

hl.window_rule({
	name = "float-modals",
	match = { modal = true },
	float = true,
	center = true,
})
hl.window_rule({
	name = "portal-file-chooser",
	match = { class = "(?i)^(xdg-desktop-portal-gtk|org\\.freedesktop\\.impl\\.portal\\.desktop\\.gtk)$" },
	float = true,
	size = { 900, 650 },
	center = true,
})

hl.window_rule({
	name = "float-proton-authenticator",
	match = { class = "proton-authenticator" },
	float = true,
	size = { 900, 650 },
	center = true,
})
