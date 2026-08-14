return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, {
      "css",
      "html_tags",
      "astro",
      "svelte",
      "vue",
    })
    vim.filetype.add({ extension = { mdx = "markdown.mdx" } })
    vim.treesitter.language.register("markdown", "markdown.mdx")
  end,
}
