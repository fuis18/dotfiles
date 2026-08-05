local mainMod = "SUPER"
local term = "kitty --single-instance"
local launcher = "anyrun"
local explorer_fast = "nautilus"
local explorer_high = "spacedrive"
local browser_fast = "brave"
local browser_high = "zen-browser"
local notify = "swaync-client"
local scriptsDir = os.getenv("HOME") .. "/.config/hypr/scripts"

-- Applications
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(term))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(launcher))
hl.bind(mainMod .. " + e", hl.dsp.exec_cmd(explorer_fast))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(explorer_high))
hl.bind(mainMod .. " + b", hl.dsp.exec_cmd(browser_fast))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser_high))

-- Hyprland Utilities
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("CTRL + ALT + DELETE", hl.dsp.exec_cmd(scriptsDir .. "/wlogout.sh"))

-- Hyprswitch (window tabs)
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("hyprswitch gui --mod-key super --key tab --close mod-key-release"))
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("hyprswitch close"), { release = true, non_consuming = true })

-- Window Management
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd(scriptsDir .. "/KillActiveProcess.sh"))

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd("hyprctl dispatch fullscreen 2"))

hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(scriptsDir .. "/clipboard.sh"))

-- Mouse: move / resize floating windows
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Workspaces
hl.bind(mainMod .. " + CTRL + left", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "+1" }))

for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -q s 10%+"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -q s 10%-"))

-- hl.bind("F2", hl.dsp.exec_cmd("brightnessctl -q s 10%+"), { locked = true, repeating = true })
-- hl.bind("F3", hl.dsp.exec_cmd("brightnessctl -q s 10%-"), { locaker = true, repeating = true })

-- Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(scriptsDir .. "/volume.sh --inc"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(scriptsDir .. "/volume.sh --dec"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(scriptsDir .. "/volume.sh --toggle-mic"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(scriptsDir .. "/volume.sh --toggle"), { locked = true })

-- hl.bind("F6", hl.dsp.exec_cmd(scriptsDir .. "/volume.sh --toggle"), { locked = true })
-- hl.bind("F7", hl.dsp.exec_cmd(scriptsDir .. "/volume.sh --dec"), { locked = true, repeating = true })
-- hl.bind("F8", hl.dsp.exec_cmd(scriptsDir .. "/volume.sh --inc"), { locked = true, repeating = true })

-- Screenshots (grimblast)
hl.bind("PRINT", hl.dsp.exec_cmd("grimblast copy screen"))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("grimblast save screen"))
hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("grimblast save area"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("grimblast copy area"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grimblast copy area"))
hl.bind(mainMod .. " + CTRL + SHIFT + S", hl.dsp.exec_cmd("grimblast edit screen"))

-- Notifications
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(notify .. " --toggle-panel"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd(notify .. " --close-latest"))

-- Performance Mode
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd(scriptsDir .. "/performance-mode.sh"))
