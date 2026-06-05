return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = {
    "williamboman/mason.nvim",
  },
  config = function()
    require("mason-tool-installer").setup({
      ensure_installed = {
        -- Formatters
        "stylua",
        "black",
        "isort",
        "rustfmt",
        "shfmt",
        "yamlfmt",
        -- Linters
        "eslint_d",
        "flake8",
        "pylint",
        -- Other
        "jq",
        "sqls",
        "prismals",
        "graphql_lsp",
        "dockerls",
        "bashls",
        "pyright",
        "yamlls",
        "jsonls",
        "tailwindcss",
        "cssls",
        "html",
        "ts_ls",
        "lua_ls",
        "rust_analyzer",
        "svelte",
      },
      auto_update = true,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 5,
    })
  end,
}
