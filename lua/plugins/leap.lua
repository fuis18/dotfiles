return {
  "https://codeberg.org/andyg/leap.nvim.git",
  event = "VeryLazy",
  config = function()
    local leap = require("leap")
    leap.opts.safe_labels = {}
    vim.keymap.set({ "n", "x", "o" }, "gs", function()
      leap.leap({ target_windows = { vim.fn.win_getid() } })
    end, { desc = "Leap (forward)" })
    vim.keymap.set({ "n", "x", "o" }, "gS", function()
      leap.leap({ target_windows = { vim.fn.win_getid() }, backward = true })
    end, { desc = "Leap (backward)" })
  end,
}
