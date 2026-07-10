return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-neotest/neotest-plenary",
    "nvim-neotest/neotest-python",
    "rouge8/neotest-rust",
  },
  keys = {
    { "<leader>nn", function() require("neotest").run.run() end, desc = "Run Nearest Test" },
    { "<leader>nN", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run All Tests in File" },
    { "<leader>nl", function() require("neotest").run.run_last() end, desc = "Run Last Test" },
    { "<leader>ns", function() require("neotest").summary.toggle() end, desc = "Test Summary" },
    { "<leader>no", function() require("neotest").output.open({ enter = true }) end, desc = "Test Output" },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-plenary"),
        require("neotest-python")({
          dap = { justMyCode = false },
        }),
        require("neotest-rust"),
      },
    })
  end,
}
