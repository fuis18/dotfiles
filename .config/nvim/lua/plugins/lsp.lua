return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    "b0o/schemastore.nvim",
  },
  config = function()
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    local on_attach = function(client, bufnr)
      local bufopts = { noremap = true, silent = true, buffer = bufnr }

      keymap("n", "gD", vim.lsp.buf.declaration, bufopts)
      keymap("n", "gd", vim.lsp.buf.definition, bufopts)
      keymap("n", "K", vim.lsp.buf.hover, bufopts)
      keymap("n", "gi", vim.lsp.buf.implementation, bufopts)
      keymap("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
      keymap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
      keymap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
      keymap("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, bufopts)
      keymap("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
      keymap("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
      keymap("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
      keymap("n", "gr", vim.lsp.buf.references, bufopts)
      keymap("n", "<leader>e", vim.diagnostic.open_float, bufopts)
      keymap("n", "[d", vim.diagnostic.goto_prev, bufopts)
      keymap("n", "]d", vim.diagnostic.goto_next, bufopts)
      keymap("n", "<leader>q", vim.diagnostic.setloclist, bufopts)
      keymap("n", "<leader>so", require("telescope.builtin").lsp_document_symbols, bufopts)
      keymap("n", "<leader>sw", require("telescope.builtin").lsp_dynamic_workspace_symbols, bufopts)

      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, {}),
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
          end,
        })
      end
    end

    local capabilities = cmp_nvim_lsp.default_capabilities()

    local function get_root_dir(fname)
      return vim.fs.root(fname, { ".git" }) or vim.fn.dirname(fname)
    end

    -- Lua
    vim.lsp.config("lua_ls", {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    -- Rust
    vim.lsp.config("rust_analyzer", {
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = get_root_dir,
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
          },
          checkOnSave = {
            command = "clippy",
          },
          procMacro = {
            enable = true,
          },
        },
      },
    })

    -- TypeScript/JavaScript
    vim.lsp.config("ts_ls", {
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = get_root_dir,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "literal",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      },
    })

    -- HTML/CSS
    vim.lsp.config("html", {
      on_attach = on_attach,
      capabilities = capabilities,
    })

    vim.lsp.config("cssls", {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        css = {
          validate = true,
          lint = {
            unknownProperties = "warning",
          },
        },
      },
    })

    -- Tailwind CSS
    vim.lsp.config("tailwindcss", {
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = get_root_dir,
      settings = {
        tailwindCSS = {
          classAttributes = { "class", "className", "classList", "ngClass" },
          includeLanguages = {
            typescript = "javascript",
            typescriptreact = "javascript",
            javascriptreact = "javascript",
          },
          lint = {
            cssConflict = "warning",
            invalidApply = "error",
            invalidScreen = "error",
            invalidVariant = "error",
            invalidConfigPath = "error",
            recommendedVariantOrder = "warning",
          },
        },
      },
    })

    -- JSON/YAML
    vim.lsp.config("jsonls", {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
        },
      },
    })

    vim.lsp.config("yamlls", {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        yaml = {
          schemas = require("schemastore").yaml.schemas(),
        },
      },
    })

    -- Python
    vim.lsp.config("pyright", {
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = get_root_dir,
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "openFilesOnly",
            useLibraryCodeForTypes = true,
          },
        },
      },
    })

    -- C/C++
    vim.lsp.config("clangd", {
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = get_root_dir,
    })

    -- Bash
    vim.lsp.config("bashls", {
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { "sh", "bash", "zsh" },
    })

    -- SQL
    vim.lsp.config("sqls", {
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = get_root_dir,
    })

    -- Prisma
    vim.lsp.config("prismals", {
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = get_root_dir,
    })

    -- GraphQL
    vim.lsp.config("graphql_lsp", {
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = get_root_dir,
      filetypes = { "graphql", "typescriptreact", "javascriptreact" },
    })

    -- Svelte
    vim.lsp.config("svelte", {
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = get_root_dir,
      filetypes = { "svelte" },
      settings = {
        svelte = {
          plugin = {
            html = {
              completions = {
                enable = true,
              },
              hover = {
                enable = true,
              },
            },
            css = {
              completions = {
                enable = true,
              },
              hover = {
                enable = true,
              },
            },
            js = {
              completions = {
                enable = true,
              },
              hover = {
                enable = true,
              },
            },
            ts = {
              completions = {
                enable = true,
              },
              hover = {
                enable = true,
              },
            },
          },
        },
      },
    })

    -- Docker
    vim.lsp.config("dockerls", {
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = get_root_dir,
    })

    -- Bash
    vim.lsp.config("bashls", {
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { "sh", "bash", "zsh" },
    })

    vim.diagnostic.config({
      virtual_text = {
        prefix = "●",
        spacing = 4,
      },
      float = {
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.HINT] = "",
          [vim.diagnostic.severity.INFO] = "",
        },
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    -- Enable all configured LSP servers
    vim.lsp.enable("lua_ls", "rust_analyzer", "ts_ls", "html", "cssls", "tailwindcss", "jsonls", "yamlls", "pyright", "clangd", "bashls", "sqls", "prismals", "graphql_lsp", "dockerls", "svelte")
  end,
}