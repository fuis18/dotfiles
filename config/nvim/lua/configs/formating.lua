-- nvim/lua/configs/formating.lua
-- https://www.josean.com/posts/neovim-linting-and-formatting

local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    svelte = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    astro = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    graphql = { "prettier" },

    lua = { "stylua" },
    python = { "isort", "black" },
    rust = { "rustfmt" },
  },

  format_on_save = {
    async = false,
    timeout_ms = 1500,
    lsp_fallback = true,
  },
})

-- Keymap manual (NORMAL + VISUAL)
vim.keymap.set({ "n", "v" }, "<leader>mp", function()
  conform.format({
    async = false,
    timeout_ms = 1500,
    lsp_fallback = true,
  })
end, { desc = "Format file or selection" })
