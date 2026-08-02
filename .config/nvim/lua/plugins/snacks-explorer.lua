return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          hidden = true,
        },
      },
    },
  },
  keys = function()
    local function open_explorer(opts)
      local explorer = Snacks.picker.get({ source = "explorer" })[1]
      if explorer then
        explorer:focus()
      else
        Snacks.explorer(opts)
      end
    end

    local function close_explorer()
      local explorer = Snacks.picker.get({ source = "explorer" })[1]
      if explorer then
        explorer:close()
      end
    end

    return {
      { "<leader>e", function() open_explorer({ cwd = LazyVim.root() }) end, desc = "Explorer Snacks (root dir)" },
      { "<leader>E", function() open_explorer({}) end, desc = "Explorer Snacks (cwd)" },
      { "<leader>ce", close_explorer, desc = "Close Explorer" },
    }
  end,
}
