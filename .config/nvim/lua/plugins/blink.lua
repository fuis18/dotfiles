return {
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        list = {
          selection = {
            auto_insert = false,
            preselect = true,
          },
        },
      },
      keymap = {
        preset = "super-tab",
        ["<C-.>"] = {
          function(cmp)
            if cmp.is_menu_visible() then
              return cmp.select_next()
            end
            return cmp.show()
          end,
        },
        ["<C-n>"] = {
          function(cmp)
            if cmp.is_menu_visible() then
              return cmp.select_next()
            end
            return cmp.show()
          end,
        },
        ["<C-p>"] = {
          function(cmp)
            if cmp.is_menu_visible() then
              return cmp.select_prev()
            end
            return cmp.show()
          end,
        },
        ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<CR>"] = {
          function(cmp)
            if cmp.is_menu_visible() then
              return cmp.accept()
            end
          end,
          "fallback",
        },
        ["<Down>"] = {
          function(cmp)
            if cmp.is_menu_visible() then
              return cmp.select_next()
            end
          end,
          "fallback",
        },
        ["<Up>"] = {
          function(cmp)
            if cmp.is_menu_visible() then
              return cmp.select_prev()
            end
          end,
          "fallback",
        },
        ["<C-e>"] = { "cancel", "fallback" },
      },
    },
  },
}
