return {
  "rafamadriz/friendly-snippets",
  config = function()
    -- Cargar snippets de friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load({
      -- Rutas donde buscar snippets
      paths = {
        "~/.config/nvim/snippets",
        "./snippets",
      },
      -- Excluir ciertos tipos de archivos
      exclude = {},
    })

    -- Cargar snippets personalizados si existen
    local custom_snippets_path = vim.fn.stdpath("config") .. "/snippets"
    if vim.fn.isdirectory(custom_snippets_path) == 1 then
      require("luasnip.loaders.from_vscode").lazy_load({ paths = { custom_snippets_path } })
    end
  end,
}
