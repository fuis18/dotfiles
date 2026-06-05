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
    {
      "williamboman/mason-lspconfig.nvim",
      config = function()
        require("mason-lspconfig").setup()
      end,
    },
  },
}