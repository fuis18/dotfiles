return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      transparent_background = false,
      term_colors = true,
      integrations = {
        cmp = true,
		gitsigns = true,
        neotree = true,
        treesitter = true,
        telescope = true,
        notify = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        indent_blankline = {
          enabled = true,
          colored_indent_levels = true,
        },
      },
    })

    vim.cmd.colorscheme "catppuccin"
  end,
}