-- Detectores de versiones de dependencias
return {
  -- package.json: muestra inline solo las dependencias con actualización disponible
  {
    "vuki656/package-info.nvim",
    ft = "json",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      hide_up_to_date = true, -- solo desactualizadas (naranja)
    },
    keys = {
      { "<leader>ps", "<cmd>PackageInfoShowForce<cr>", desc = "Refresh Versions" },
      { "<leader>pu", "<cmd>PackageInfoUpdate<cr>", desc = "Update Dependency (line)" },
      { "<leader>pi", "<cmd>PackageInfoInstall<cr>", desc = "Install Dependency" },
      { "<leader>pd", "<cmd>PackageInfoDelete<cr>", desc = "Delete Dependency" },
      { "<leader>pc", "<cmd>PackageInfoChangeVersion<cr>", desc = "Change Version" },
    },
  },

  -- Cargo.toml: detección inline de crates con versión superior
  {
    "Saecki/crates.nvim",
    tag = "stable",
    event = { "BufRead Cargo.toml" },
    opts = {
      on_attach = function(bufnr)
        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
        end
        map("<leader>pv", function() require("crates").show_versions_popup() end, "Crate Versions")
        map("<leader>pu", function() require("crates").update_crate() end, "Update Crate (compatible)")
        map("<leader>pU", function() require("crates").upgrade_crate() end, "Upgrade Crate (latest)")
        map("<leader>pa", function() require("crates").upgrade_all_crates() end, "Upgrade All Crates")
      end,
    },
  },

  -- Agrupa los atajos bajo <leader>p en which-key
  {
    "folke/which-key.nvim",
    opts = { spec = { { "<leader>p", group = "packages", mode = { "n", "x" } } } },
  },
}
