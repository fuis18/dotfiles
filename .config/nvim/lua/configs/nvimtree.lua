-- nvim/lua/configs/nvimtree.lua

return {
  filters = {
    dotfiles = true,
  },

  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = false,
  sync_root_with_cwd = true,

  update_focused_file = {
    enable = true,
    update_root = false,
  },

  view = {
    adaptive_size = false,
    side = "right",
    width = 30,
    preserve_window_proportions = true,
  },

  git = {
    enable = false,
    ignore = true,
  },

  filesystem_watchers = {
    enable = true,
  },

  actions = {
    open_file = {
      resize_window = true,
    },
  },

  renderer = {
    root_folder_label = false,
    highlight_git = false,
    highlight_opened_files = "none",

    indent_markers = {
      enable = false,
    },

    icons = {
      web_devicons = {
        file = {
          enable = true,
          color = true,
        },
        folder = {
          enable = true,
          color = true,
        },
      },
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = false,
      },
    },
  },
}
