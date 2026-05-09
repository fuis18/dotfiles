return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- Leer el logo ASCII de hydra
    local function read_hydra_logo()
      local file = io.open(vim.fn.stdpath("config") .. "/hydra.txt", "r")
      if not file then
        return { "HYDRA" }
      end
      local content = file:read("*all")
      file:close()
      
      -- Convertir el contenido a tabla de líneas
      local lines = {}
      for line in content:gmatch("[^\r\n]+") do
        table.insert(lines, line)
      end
      return lines
    end

    -- Obtener colores según el tema actual
    local function get_theme_colors()
      local colors = {
        catppuccin = {
          bg = "#1e1e2e",
          fg = "#cdd6f4", 
          blue = "#89b4fa",  -- Azul suave mocha
          green = "#a6e3a1", -- Verde suave mocha
          yellow = "#f9e2af", -- Amarillo suave mocha
          red = "#f38ba8",   -- Rojo suave mocha
          purple = "#cba6f7", -- Púrpura suave mocha
        },
        oxocarbon = {
          bg = "#161616",
          fg = "#f2f4f8",
          blue = "#666666",   -- Gris oscuro (monocromático)
          green = "#666666",  -- Gris oscuro (monocromático)
          yellow = "#666666", -- Gris oscuro (monocromático)
          red = "#666666",    -- Gris oscuro (monocromático)
          purple = "#666666",  -- Gris oscuro (monocromático)
        }
      }
      
      -- Detectar tema actual
      local current_theme = vim.g.colors_name or "default"
      if current_theme:match("catppuccin") then
        return colors.catppuccin
      elseif current_theme:match("oxocarbon") then
        return colors.oxocarbon
      else
        return colors.oxocarbon -- fallback a oxocarbon
      end
    end

    local colors = get_theme_colors()

    local hydra_logo = read_hydra_logo()
    
    require("dashboard").setup({
      theme = "hyper",
      config = {
        header = hydra_logo,
        week_header = {
          enable = false,
        },
        shortcut = {
          {
            icon = "  ",
            icon_hl = "DashboardRecent",
            desc = "Find File",
            desc_hl = "DashboardDesc",
            key = "f",
            key_hl = "DashboardKey",
            action = "Telescope find_files",
          },
          {
            icon = "  ",
            icon_hl = "DashboardRecent",
            desc = "Recent Files",
            desc_hl = "DashboardDesc",
            key = "r",
            key_hl = "DashboardKey",
            action = "Telescope oldfiles",
          },
          {
            icon = "  ",
            icon_hl = "DashboardRecent",
            desc = "Theme Switch",
            desc_hl = "DashboardDesc",
            key = "t",
            key_hl = "DashboardKey",
            action = "lua require('configs.telescope-colorscheme').pick_colorscheme()",
          },
          {
            icon = "  ",
            icon_hl = "DashboardRecent",
            desc = "Quit",
            desc_hl = "DashboardDesc",
            key = "q",
            key_hl = "DashboardKey",
            action = "qa",
          },
        },
        project = {
          enable = false,
        },
        mru = {
          limit = 5,
          icon = "  ",
          label = "Recent Files",
        },
        footer = {
          "  ",
          "  ",
        },
      },
      hide = {
        statusline = true,
        tabline = true,
        winbar = true,
      },
    })

    -- Configurar highlights personalizados
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        local colors = get_theme_colors()
        
        -- Highlights para el dashboard
        vim.api.nvim_set_hl(0, "DashboardHeader", { fg = colors.blue, bg = colors.bg })
        vim.api.nvim_set_hl(0, "DashboardCenter", { fg = colors.fg, bg = colors.bg })
        vim.api.nvim_set_hl(0, "DashboardShortcut", { fg = colors.yellow, bg = colors.bg })
        vim.api.nvim_set_hl(0, "DashboardFooter", { fg = colors.purple, bg = colors.bg })
        vim.api.nvim_set_hl(0, "DashboardDesc", { fg = colors.fg, bg = colors.bg })
        vim.api.nvim_set_hl(0, "DashboardKey", { fg = colors.green, bg = colors.bg })
        vim.api.nvim_set_hl(0, "DashboardRecent", { fg = colors.blue, bg = colors.bg })
        vim.api.nvim_set_hl(0, "DashboardProjectTitle", { fg = colors.purple, bg = colors.bg })
        vim.api.nvim_set_hl(0, "DashboardProjectTitleIcon", { fg = colors.yellow, bg = colors.bg })
        vim.api.nvim_set_hl(0, "DashboardProjectIcon", { fg = colors.blue, bg = colors.bg })
      end,
    })

    -- Comando para mostrar dashboard manualmente
    vim.api.nvim_create_user_command("Dashboard", function()
      require("dashboard"):instance()
    end, {})
  end,
}
