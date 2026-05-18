return {
  "Betelgeuse1/zealua.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("zealua").setup({
      -- Configuración de Zeal
      zeal_command = "zeal",
      -- Mapeos de teclas
      mappings = {
        -- Mapeo para buscar la palabra bajo el cursor
        docstring_under_cursor = "<leader>z",
        -- Mapeo para buscar una palabra específica
        docstring_visual = "<leader>Z",
      },
    })

    -- Keymaps
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Buscar documentación de la palabra bajo el cursor
    keymap("n", "<leader>z", "<cmd>Zealua<CR>", opts)
    keymap("v", "<leader>z", "<cmd>Zealua<CR>", opts)
  end,
}
