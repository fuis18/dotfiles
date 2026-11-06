return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- Web
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        svelte = { "prettier" },
        astro = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        html = { "prettier" },
        graphql = { "prettier" },
        -- Datos
        json = { "prettier" },
        jsonc = { "prettier" },
        json5 = { "prettier" },
        yaml = { "prettier" },
        yml = { "prettier" },
        -- Markdown
        markdown = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
        -- Lua y shell: stylua / shfmt (defaults de LazyVim, ya instalados)
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "prettier" },
    },
  },
}
