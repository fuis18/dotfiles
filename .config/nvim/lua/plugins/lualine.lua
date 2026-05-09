return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "linrongbin16/lsp-progress.nvim",
  },
  event = "VeryLazy",
  config = function()
    local colors = {
      bg = "#1a1b26",
      fg = "#c0caf5",
      yellow = "#e0af68",
      cyan = "#7dcfff",
      darkblue = "#414868",
      green = "#9ece6a",
      orange = "#ff9e64",
      violet = "#bb9af7",
      magenta = "#f7768e",
      blue = "#7aa2f7",
      red = "#f7768e",
    }

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end,
      check_git_workspace = function()
        local filepath = vim.fn.expand("%:p:h")
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
      end,
    }

    -- Configuración de colores
    local mode_color = {
      n = colors.green,
      i = colors.blue,
      v = colors.violet,
      [""] = colors.violet,
      V = colors.violet,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [""] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ["r?"] = colors.cyan,
      ["!"] = colors.red,
      t = colors.red,
    }

    local config = {
      options = {
        component_separators = "",
        section_separators = "",
        theme = {
          normal = { c = { fg = colors.fg, bg = colors.bg } },
          inactive = { c = { fg = colors.fg, bg = colors.bg } },
        },
        disabled_filetypes = { "alpha", "dashboard", "NvimTree", "ToggleTerm" },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            color = function()
              return { fg = mode_color[vim.fn.mode()] }
            end,
            padding = { left = 1, right = 1 },
          },
        },
        lualine_b = {
          {
            "branch",
            icon = "",
            color = { fg = colors.violet },
            cond = conditions.check_git_workspace,
          },
          {
            "diff",
            colored = true,
            diff_color = {
              added = { fg = colors.green },
              modified = { fg = colors.orange },
              removed = { fg = colors.red },
            },
            cond = conditions.hide_in_width,
          },
        },
        lualine_c = {
          {
            "filename",
            file_status = true,
            path = 1,
            symbols = {
              modified = "[+]",
              readonly = "[ ]",
              unnamed = "[No Name]",
            },
            color = { fg = colors.fg },
            cond = conditions.buffer_not_empty,
          },
          {
            "lsp_progress",
            display_components = { "lsp_client_name", "spinner", { "title", "percentage" } },
            spinner_symbols = { " ", " ", " ", " ", " ", " " },
            timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
            separator = " ",
            lsp_client_name = {
              icon = " LSP:",
              name = "lsp_client_name",
              color = { fg = colors.cyan },
            },
            percentage = {
              icon = " [",
              name = "percentage",
              color = { fg = colors.green },
              format = function(str)
                return str .. "]"
              end,
            },
            title = {
              icon = " ",
              name = "title",
              color = { fg = colors.yellow },
            },
            spinner = {
              icon = " ",
              name = "spinner",
              color = { fg = colors.orange },
            },
          },
        },
        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = "", warn = "", info = "", hint = "" },
            diagnostics_color = {
              color_error = { fg = colors.red },
              color_warn = { fg = colors.yellow },
              color_info = { fg = colors.cyan },
              color_hint = { fg = colors.blue },
            },
          },
          {
            "o:encoding",
            fmt = string.upper,
            cond = conditions.hide_in_width,
            color = { fg = colors.green },
          },
          {
            "fileformat",
            symbols = {
              unix = "",
              dos = "",
              mac = "",
            },
            color = { fg = colors.green },
          },
        },
        lualine_y = {
          {
            "progress",
            color = { fg = colors.fg },
            separator = " ",
          },
          {
            "location",
            color = { fg = colors.fg },
          },
        },
        lualine_z = {
          {
            function()
              return " "
            end,
            color = function()
              return { fg = mode_color[vim.fn.mode()] }
            end,
            padding = { left = 1, right = 1 },
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            "filename",
            file_status = true,
            path = 1,
            symbols = {
              modified = "[+]",
              readonly = "[ ]",
              unnamed = "[No Name]",
            },
            color = { fg = colors.fg },
            cond = conditions.buffer_not_empty,
          },
        },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { "nvim-tree", "fugitive", "toggleterm" },
    }

    require("lualine").setup(config)

    -- Configuración para lsp-progress.nvim
    require("lsp-progress").setup({
      format = function(client_messages)
        if #client_messages == 0 then
          return nil
        end
        local table_concat = table.concat
        local sign_names = vim.lsp.protocol.ProgressToken[client_messages[1].name] or { kind = "end", title = client_messages[1].name }
        local sign = sign_names.kind == "end" and "" or ""
        return table_concat(client_messages, " ", function(msg)
          return string.format("%s %s", sign, msg.title)
        end)
      end,
    })
  end,
}
