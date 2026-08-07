local nav_mode = false

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    nav_mode = false
  end,
})

local function select(direction)
  return {
    function(cmp)
      if nav_mode and cmp.is_menu_visible() then
        if direction == "next" then
          return cmp.select_next()
        end
        return cmp.select_prev()
      end
    end,
    "fallback",
  }
end

return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        list = {
          selection = {
            auto_insert = false,
            preselect = false,
          },
        },
      },
      keymap = {
        preset = "super-tab",
        ["<Tab>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.snippet_forward()
            end
          end,
          function(cmp)
            nav_mode = true
            if cmp.is_menu_visible() then
              return cmp.select_next()
            end
            return cmp.show({ initial_selected_item_idx = 1 })
          end,
          "fallback",
        },
        ["<S-Tab>"] = {
          function(cmp)
            nav_mode = true
            if cmp.is_menu_visible() then
              return cmp.select_prev()
            end
            return cmp.show({ initial_selected_item_idx = -1 })
          end,
          "fallback",
        },
        ["<CR>"] = {
          function(cmp)
            if nav_mode and cmp.is_menu_visible() then
              nav_mode = false
              return cmp.accept()
            end
          end,
          "fallback",
        },
        ["<Down>"] = select("next"),
        ["<Up>"] = select("prev"),
        ["<C-n>"] = {
          function(cmp)
            if nav_mode and cmp.is_menu_visible() then
              return cmp.select_next()
            end
          end,
          "fallback_to_mappings",
        },
        ["<C-p>"] = {
          function(cmp)
            if nav_mode and cmp.is_menu_visible() then
              return cmp.select_prev()
            end
          end,
          "fallback_to_mappings",
        },
        ["<C-e>"] = {
          function(cmp)
            nav_mode = false
            return cmp.cancel()
          end,
          "fallback",
        },
      },
    },
  },
}
