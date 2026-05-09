return {
  "williamboman/mason.nvim",
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason_tool_installer = require("mason-tool-installer")

    mason_tool_installer.setup({
      ensure_installed = {
        -- Formatters
        "prettier",
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