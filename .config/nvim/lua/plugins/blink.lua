local nav_mode = false

local function reset_nav()
  nav_mode = false
end

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = reset_nav,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpHide",
  callback = reset_nav,
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

local function activate(direction)
  return function(cmp)
    nav_mode = true
    if cmp.is_menu_visible() then
      if direction == "next" then
        return cmp.select_next()
      end
      return cmp.select_prev()
    end
    if direction == "next" then
      return cmp.show({ initial_selected_item_idx = 1 })
    end
    return cmp.show({ initial_selected_item_idx = -1 })
  end
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
        ["<C-.>"] = { activate("next") },
        ["<C-n>"] = { activate("next") },
        ["<C-p>"] = { activate("prev") },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
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
