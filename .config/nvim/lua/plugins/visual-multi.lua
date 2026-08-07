return {
  "mg979/vim-visual-multi",
  event = "VeryLazy",
  init = function()
    vim.g.VM_maps = {
      ["Find Under"] = "<C-n>",
      ["Find Subword Under"] = "<C-n>",
      ["Find Next"] = "",
      ["Find Prev"] = "",
      ["Add Cursor Up"] = "<C-Up>",
      ["Add Cursor Down"] = "<C-Down>",
    }
    vim.g.VM_highlight_matches = "underline"
  end,
}
