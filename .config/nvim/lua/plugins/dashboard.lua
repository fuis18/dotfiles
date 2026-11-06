return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    local hydra_path = vim.fn.stdpath("config") .. "/hydra.txt"
    local file = io.open(hydra_path, "r")
    if file then
      opts.dashboard = opts.dashboard or {}
      opts.dashboard.preset = opts.dashboard.preset or {}
      opts.dashboard.preset.header = file:read("*all")
      file:close()
    end
    return opts
  end,
}
