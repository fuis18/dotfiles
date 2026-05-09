local themes = {
  "catppuccin",
  "oxocarbon",
}

local function switch_colorscheme(theme)
  vim.cmd("colorscheme " .. theme)
  vim.notify("Theme changed to: " .. theme, vim.log.levels.INFO)
end

local function pick_colorscheme()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers.new({}, {
    prompt_title = "Colorschemes",
    finder = finders.new_table({
      results = themes,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        switch_colorscheme(selection[1])
      end)
      return true
    end,
  }):find()
end

return {
  pick_colorscheme = pick_colorscheme,
  switch_colorscheme = switch_colorscheme,
  themes = themes,
}
