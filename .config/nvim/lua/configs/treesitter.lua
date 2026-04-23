-- nvim/lua/configs/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local base_languages = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "python",
        "yaml",
      }

      local unix_languages = { "c", "cpp", "zig", "rust", "svelte", "astro" }

      if vim.fn.has("unix") == 1 then
        vim.list_extend(base_languages, unix_languages)
      end

      require("nvim-treesitter.configs").setup({
        ensure_installed = base_languages,
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })

      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },
}
