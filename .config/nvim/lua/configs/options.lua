-- lua/configs/options.lua

local opt = vim.opt
local g = vim.g

-- Basic Settings
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.stdpath("data") .. "/undodir"
opt.undofile = true

-- UI/UX
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.colorcolumn = "80"
opt.wrap = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Indentation
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- Folding
opt.foldmethod = "syntax"
opt.foldlevelstart = 99

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.wildmode = "longest:full,full"

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300
opt.ttimeoutlen = 10

-- Netrw settings (temporary until oil.nvim is set up)
g.netrw_banner = 0
g.netrw_liststyle = 3
g.netrw_browse_split = 0
g.netrw_altv = 1
g.netrw_winsize = 25