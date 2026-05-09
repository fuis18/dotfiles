return {
  "simrat39/rust-tools.nvim",
  ft = { "rust" },
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },
  config = function()
    local rust_tools = require("rust-tools")

    -- Configuración de LSP para Rust
    local lsp_opts = {
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
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
          completion = {
            addCallParentheses = true,
            addCallArgumentSnippets = true,
            postfix = {
              enable = true,
            },
          },
        },
      },
    }

    -- Configuración de rust-tools
    rust_tools.setup({
      tools = {
        -- Configuración para auto-setear el hover
        inlay_hints = {
          auto = true,
          show_parameter_hints = true,
          parameter_hints_prefix = "<- ",
          other_hints_prefix = "=> ",
          max_len_align = false,
          max_len_align_padding = 1,
          right_align = false,
          right_align_padding = 7,
          highlight = "Comment",
        },
        -- Configuración para el hover
        hover_actions = {
          auto_focus = true,
          border = "rounded",
        },
        -- Configuración para runnables
        runnables = {
          use_telescope = true,
        },
        -- Configuración para debuggables
        debuggables = {
          use_telescope = true,
        },
        -- Configuración para codelens
        codelens = {
          show_test = true,
          show_run = true,
          show_impl = true,
          show_method = true,
          enabled = true,
        },
        -- Configuración para expandir macros
        expand_macro = {
          prefix = "=> ",
        },
        -- Configuración para abrir cargo.toml
        open_cargo_toml = {
          auto_focus = true,
        },
        -- Configuración para crate graph
        crate_graph = {
          backend = "dot",
          output = nil,
          enabled_graphviz_backends = { "dot", "xdot", "circo", "fdp", "neato", "twopi" },
          full = true,
          theme = "normal",
        },
        -- Configuración para external docs
        external_docs = {
          auto_open = true,
          auto_focus = true,
        },
      },
      -- Configuración del servidor
      server = lsp_opts,
      -- Configuración de DAP
      dap = {
        adapter = {
          type = "executable",
          command = "lldb-vscode",
          name = "rt_lldb",
        },
      },
    })

    -- Keymaps específicos para Rust
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Rust specific keymaps
    keymap("n", "<leader>rr", "<cmd>RustRunnables<CR>", opts) -- Run/debug
    keymap("n", "<leader>rc", "<cmd>RustOpenCargo<CR>", opts) -- Open Cargo.toml
    keymap("n", "<leader>rh", "<cmd>RustHoverActions<CR>", opts) -- Hover actions
    keymap("n", "<leader>re", "<cmd>RustExpandMacro<CR>", opts) -- Expand macro
    keymap("n", "<leader>rR", "<cmd>RustRunnables<CR>", opts) -- Run
    keymap("n", "<leader>rd", "<cmd>RustDebuggables<CR>", opts) -- Debug
    keymap("n", "<leader>rD", "<cmd>RustEnableDap<CR>", opts) -- Enable DAP
    keymap("n", "<leader>rt", "<cmd>RustTestNearest<CR>", opts) -- Test nearest
    keymap("n", "<leader>rT", "<cmd>RustTestAll<CR>", opts) -- Test all
    keymap("n", "<leader>rm", "<cmd>RustExpandMacro<CR>", opts) -- Expand macro
    keymap("n", "<leader>rg", "<cmd>RustViewCrateGraph<CR>", opts) -- View crate graph
    keymap("n", "<leader>rE", "<cmd>RustExternalDocs<CR>", opts) -- External docs

    -- Configuración para inlay hints
    vim.g.rustaceanvim = {
      inlay_hints = {
        highlight = "NonText",
      },
    }

    -- Comandos útiles
    vim.api.nvim_create_user_command("RustTest", function(opts)
      local test_name = opts.args
      if test_name == "" then
        vim.cmd("RustTestNearest")
      else
        vim.cmd("RustTest " .. test_name)
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
  end,
}
