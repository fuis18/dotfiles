return {
  "saecki/crates.nvim",
  ft = { "toml" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("crates").setup({
      src = {
        cmp = {
          enabled = true,
        },
        telescope = {
          enabled = true,
        },
      },
      null_ls = {
        enabled = true,
        name = "crates.nvim",
      },
      popup = {
        autofocus = true,
        copy_register = "\"",
        style = "minimal",
        border = "rounded",
        show_version_date = true,
        show_dependency_version = true,
        max_height = 30,
        min_width = 20,
        padding = 1,
      },
      text = {
        prerelease = " pre-release ",
        yanked = " yanked ",
        version = " v",
        version_date = " (",
        version_date_end = ")",
        feature = " +",
        dependency = " depends on ",
        dependency_version = " v",
        dependency_date = " (",
        dependency_date_end = ")",
      },
      highlight = {
        version = "CratesVersion",
        prerelease = "CratesPreRelease",
        yanked = "CratesYanked",
        version_date = "CratesVersionDate",
        feature = "CratesFeature",
        dependency = "CratesDependency",
        dependency_version = "CratesDependencyVersion",
        dependency_date = "CratesDependencyDate",
      },
      on_attach = function(bufnr)
        local opts = { silent = true, buffer = bufnr }
        local keymap = vim.keymap.set

        -- Keymaps para crates.nvim
        keymap("n", "<leader>cu", "<cmd>CratesUpdate<CR>", opts)
        keymap("n", "<leader>cU", "<cmd>CratesUpgrade<CR>", opts)
        keymap("n", "<leader>ca", "<cmd>CratesUpdateAll<CR>", opts)
        keymap("n", "<leader>cA", "<cmd>CratesUpgradeAll<CR>", opts)
        keymap("n", "<leader>ch", "<cmd>CratesHide<CR>", opts)
        keymap("n", "<leader>cs", "<cmd>CratesShow<CR>", opts)
        keymap("n", "<leader>cf", "<cmd>CratesShowFeatures<CR>", opts)
        keymap("n", "<leader>ci", "<cmd>CratesShowInfo<CR>", opts)
        keymap("n", "<leader>cD", "<cmd>CratesShowDependencies<CR>", opts)
        keymap("n", "<leader>cH", "<cmd>CratesHome<CR>", opts)
        keymap("n", "<leader>cR", "<cmd>CratesRepo<CR>", opts)
        keymap("n", "<leader>cD", "<cmd>CratesDocs<CR>", opts)
      end,
    })

    -- Configuración de highlights
    vim.api.nvim_set_hl(0, "CratesVersion", { fg = "#89b4fa", bold = true })
    vim.api.nvim_set_hl(0, "CratesPreRelease", { fg = "#f9e2af", bold = true })
    vim.api.nvim_set_hl(0, "CratesYanked", { fg = "#f38ba8", bold = true, strikethrough = true })
    vim.api.nvim_set_hl(0, "CratesVersionDate", { fg = "#a6e3a1" })
    vim.api.nvim_set_hl(0, "CratesFeature", { fg = "#cba6f7" })
    vim.api.nvim_set_hl(0, "CratesDependency", { fg = "#f2f4f8" })
    vim.api.nvim_set_hl(0, "CratesDependencyVersion", { fg = "#89b4fa" })
    vim.api.nvim_set_hl(0, "CratesDependencyDate", { fg = "#a6e3a1" })
  end,
}
