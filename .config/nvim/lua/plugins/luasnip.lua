return {
  "L3MON4D3/LuaSnip",
  config = function()
    local luasnip = require("luasnip")

    -- Configuración de LuaSnip
    luasnip.config.set_config({
      -- Habilitar autotrigger de snippets
      enable_autosnippets = true,
      -- Actualizar eventos cuando se escribe
      update_events = "TextChanged,TextChangedI",
      -- Historial de snippets
      history = true,
      -- Borrar el snippet cuando se borra el texto
      delete_check_events = "TextChanged",
    })

    -- Keymaps para LuaSnip
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Expandir snippet o saltar al siguiente placeholder
    keymap({ "i", "s" }, "<C-l>", function()
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-l>", true, true, true), "n", false)
      end
    end, opts)

    -- Saltar al placeholder anterior
    keymap({ "i", "s" }, "<C-h>", function()
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-h>", true, true, true), "n", false)
      end
    end, opts)

    -- Seleccionar el siguiente choice
    keymap({ "i", "s" }, "<C-j>", function()
      if luasnip.choice_active() then
        luasnip.change_choice(1)
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-j>", true, true, true), "n", false)
      end
    end, opts)

    -- Seleccionar el choice anterior
    keymap({ "i", "s" }, "<C-k>", function()
      if luasnip.choice_active() then
        luasnip.change_choice(-1)
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-k>", true, true, true), "n", false)
      end
    end, opts)
  end,
}
