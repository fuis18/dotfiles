---@meta

---@class hl.dsp.window
local dsp_window = {}

---@param opts? { action: string } @ e.g. { action = "toggle" } or { action = "maximize" }
---@return string
function dsp_window.fullscreen(opts) end

---@param opts? { action: string } @ e.g. { action = "toggle" }
---@return string
function dsp_window.float(opts) end

---@param opts? { workspace: integer|string } @ e.g. { workspace = 2 } or { workspace = "special" }
---@return string
function dsp_window.move(opts) end

---@return string
function dsp_window.close() end

---@return string
function dsp_window.drag() end

---@return string
function dsp_window.resize() end

---@return string
function dsp_window.pin() end

---@return string
function dsp_window.deny_from_group() end

---@return string
function dsp_window.swapNext() end

---@return string
function dsp_window.swapPrev() end

---@class hl.dsp
local dsp = {}

---@type hl.dsp.window
dsp.window = {}

---@param cmd string
---@return string
function dsp.exec_cmd(cmd) end

---@param opts { direction: string } | { workspace: integer|string }
---@return string
function dsp.focus(opts) end

---@param opts { workspace: integer|string }
---@return string
function dsp.workspace(opts) end

---@param opts { monitor: string }
---@return string
function dsp.focusMonitor(opts) end

---@param opts { gaps: integer }
---@return string
function dsp.setsGaps(opts) end

---@param opts { border: integer }
---@return string
function dsp.setsBorder(opts) end

---@class hl.dsp.group
local dsp_group = {}

---@param opts? { window?: string }
---@return string
function dsp_group.toggle(opts) end

---@param opts? { window?: string }
---@return string
function dsp_group.next(opts) end

---@param opts? { window?: string }
---@return string
function dsp_group.prev(opts) end

---@param opts { index: integer, window?: string }
---@return string
function dsp_group.active(opts) end

---@param opts? { forward?: boolean, window?: string }
---@return string
function dsp_group.move_window(opts) end

---@param opts? { action?: string, window?: string }
---@return string
function dsp_group.lock(opts) end

---@param opts? { action?: string }
---@return string
function dsp_group.lock_active(opts) end

---@class hl.dsp
local dsp = {}

---@type hl.dsp.window
dsp.window = {}

---@type hl.dsp.group
dsp.group = {}

---@param opts { to: string, cycles: integer }
function dsp.scrollOpts(opts) end

---@class hl
local hl = {}

---@type hl.dsp
hl.dsp = dsp

---@param config table
function hl.config(config) end

---@param opts { output: string, mode: string, position: string, scale: number }
function hl.monitor(opts) end

---@param key string
---@param val string
function hl.env(key, val) end

---@param event string @ e.g. "hyprland.start", "hyprland.reload", "window.open", "window.close", "workspace.change", "monitor.add", "monitor.remove", "activewindow.change", "fullscreen.change"
---@param callback function
function hl.on(event, callback) end

---@param key string e.g. "SUPER + RETURN"
---@param dispatcher string
---@param opts? { release: boolean, non_consuming: boolean, locked: boolean, mouse: boolean, repeating: boolean, description: string }
function hl.bind(key, dispatcher, opts) end

---@param opts { name: string, match: { class?: string, title?: string, float?: boolean, modal?: boolean }, float?: boolean, size?: { [1]: integer, [2]: integer }, center?: boolean, pinned?: boolean, nofocus?: boolean, noborder?: boolean, noblur?: boolean, opaque?: boolean, rounding?: boolean, workspace?: string, fullscreen?: integer, maximize?: boolean, group?: string, bordercolor?: string }
function hl.window_rule(opts) end

---@param opts { workspace: integer|string, monitor: string, default: boolean, gaps_in: integer, gaps_out: integer, border_size: integer, border_color: string, layout: string }
function hl.workspace_rule(opts) end

---@param time integer milliseconds
---@param callback fun(): boolean @ return true to repeat, false to stop
---@return integer timer_id
function hl.timer(time, callback) end

---@param id integer
function hl.cancel_timer(id) end

---@return string @ the layout name for the current workspace
function hl.currentLayout() end

---@param text string
---@param time? integer ms
function hl.notify(text, time) end
