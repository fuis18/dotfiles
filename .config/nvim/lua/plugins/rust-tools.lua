return {
  "mrcjkb/rustaceanvim",
  version = "^5",
  ft = { "rust" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },
  config = function()
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Rust specific keymaps
    keymap("n", "<leader>rr", "<cmd>RustLsp runnables<CR>", opts)
    keymap("n", "<leader>rc", "<cmd>RustLsp openCargo<CR>", opts)
    keymap("n", "<leader>rh", "<cmd>RustLsp hoverActions<CR>", opts)
    keymap("n", "<leader>re", "<cmd>RustLsp expandMacro<CR>", opts)
    keymap("n", "<leader>rd", "<cmd>RustLsp debuggables<CR>", opts)
    keymap("n", "<leader>rt", "<cmd>RustLsp testables<CR>", opts)
    keymap("n", "<leader>rg", "<cmd>RustLsp crateGraph<CR>", opts)
    keymap("n", "<leader>rE", "<cmd>RustLsp externalDocs<CR>", opts)

    -- Comandos útiles
    vim.api.nvim_create_user_command("RustTest", function(opts)
      local test_name = opts.args
      if test_name == "" then
        vim.cmd("RustLsp testables")
      else
        vim.cmd("RustLsp testables " .. test_name)
      end
    end, {
      nargs = "?",
      desc = "Run Rust test (nearest if no name provided)",
    })

    vim.api.nvim_create_user_command("RustBuild", function()
      vim.cmd("!cargo build")
    end, {
      desc = "Build Rust project",
    })

    vim.api.nvim_create_user_command("RustClean", function()
      vim.cmd("!cargo clean")
    end, {
      desc = "Clean Rust project",
    })

    vim.api.nvim_create_user_command("RustCheck", function()
      vim.cmd("!cargo check")
    end, {
      desc = "Check Rust project",
    })

    vim.api.nvim_create_user_command("RustClippy", function()
      vim.cmd("!cargo clippy --all -- -D warnings")
    end, {
      desc = "Run Clippy on Rust project",
    })

    vim.g.rustaceanvim = {
      server = {
        cmd = function()
          return { "rust-analyzer" }
        end,
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
            },
            checkOnSave = {
              command = "clippy",
              extraArgs = { "--all", "--", "-W", "clippy::all" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = true,
                ["napi-derive"] = true,
                ["async-stream"] = true,
              },
            },
            inlayHints = {
              bindingModeHints = {
                enable = true,
              },
              chainingHints = {
                enable = true,
              },
              closingBraceHints = {
                enable = true,
                minLines = 25,
              },
              discriminantHints = {
                enable = true,
              },
              lifetimeElisionHints = {
                enable = "always",
                useParameterNames = true,
              },
              maxLength = 25,
              parameterHints = {
                enable = true,
              },
              reborrowHints = {
                enable = "always",
              },
              renderColons = true,
              typeHints = {
                enable = true,
                hideClosureInitialization = false,
                hideNamedConstructor = false,
              },
            },
            diagnostics = {
              enable = true,
              disabled = { "unresolved-proc-macro" },
              enableExperimental = true,
            },
          },
        },
      },
      dap = {
        adapter = {
          type = "executable",
          command = "lldb-vscode",
          name = "rt_lldb",
        },
      },
    }
  end,
}
