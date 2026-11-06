return {
  "kylechui/nvim-surround",
  version = "^4.0.0",
  event = "VeryLazy",
  config = function()
    local maps = {
      { "i", "<C-g>s", "<Plug>(nvim-surround-insert)", "Add a surrounding pair around the cursor (insert mode)" },
      { "i", "<C-g>S", "<Plug>(nvim-surround-insert-line)", "Add a surrounding pair around the cursor, on new lines (insert mode)" },
      { "n", "ys", "<Plug>(nvim-surround-normal)", "Add a surrounding pair around a motion (normal mode)" },
      { "n", "yss", "<Plug>(nvim-surround-normal-cur)", "Add a surrounding pair around the current line (normal mode)" },
      { "n", "yS", "<Plug>(nvim-surround-normal-line)", "Add a surrounding pair around a motion, on new lines (normal mode)" },
      { "n", "ySS", "<Plug>(nvim-surround-normal-cur-line)", "Add a surrounding pair around the current line, on new lines (normal mode)" },
      { "x", "S", "<Plug>(nvim-surround-visual)", "Add a surrounding pair around a visual selection" },
      { "x", "gS", "<Plug>(nvim-surround-visual-line)", "Add a surrounding pair around a visual selection, on new lines" },
      { "n", "ds", "<Plug>(nvim-surround-delete)", "Delete a surrounding pair" },
      { "n", "cs", "<Plug>(nvim-surround-change)", "Change a surrounding pair" },
      { "n", "cS", "<Plug>(nvim-surround-change-line)", "Change a surrounding pair, putting replacements on new lines" },
    }
    for _, m in ipairs(maps) do
      vim.keymap.set(m[1], m[2], m[3], { desc = m[4] })
    end
  end,
}
