-- nvim/lua/configs/mappings.lua
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

--Basic settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.wo.relativenumber = true
vim.wo.number = true

map("n", "<leader>e", vim.cmd.NvimTreeFocus, opts)

-- Window Navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Buffer Navigation
map("n", "<Tab>", vim.cmd.bnext, opts)
map("n", "<S-Tab>", vim.cmd.bprevious, opts)

map("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", opts)
map("n", "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", opts)
map("n", "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", opts)
map("n", "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", opts)
map("n", "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>", opts)
map("n", "<leader>6", "<cmd>BufferLineGoToBuffer 6<CR>", opts)
map("n", "<leader>7", "<cmd>BufferLineGoToBuffer 7<CR>", opts)
map("n", "<leader>8", "<cmd>BufferLineGoToBuffer 8<CR>", opts)
map("n", "<leader>9", "<cmd>BufferLineGoToBuffer 9<CR>", opts)

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)

-- Theme switching
local colorscheme_picker = require("configs.telescope-colorscheme")
map("n", "<leader>th", colorscheme_picker.pick_colorscheme, opts)