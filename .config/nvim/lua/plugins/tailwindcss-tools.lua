return {
  "luckasRanarison/tailwind-tools.nvim",
  ft = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte", "astro" },
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("tailwind-tools").setup({
      -- Configuración de color picker
      color_picker = {
        enable = true,
        fallback = true,
      },
      -- Configuración de documentación
      document_color = {
        enabled = true,
        kind = "inline",
        inline_symbol = "󰥔 ",
        debounce = 200,
      },
      -- Configuración de extensión de archivos
      extend_filetypes = {
        javascript = { "javascript" },
        typescript = { "typescript" },
        javascriptreact = { "javascriptreact" },
        typescriptreact = { "typescriptreact" },
        vue = { "vue" },
        svelte = { "svelte" },
        astro = { "astro" },
        html = { "html" },
        css = { "css" },
        scss = { "scss" },
        less = { "less" },
      },
      -- Configuración de LSP
      server = {
        override = false, -- No sobreescribir la configuración existente
        settings = {
          tailwindCSS = {
            classAttributes = { "class", "className", "classList", "ngClass", "class:list" },
            includeLanguages = {
              typescript = "javascript",
              typescriptreact = "javascript",
              javascriptreact = "javascript",
              vue = "html",
              svelte = "html",
              astro = "html",
              html = "html",
              css = "css",
              scss = "css",
              less = "css",
            },
            lint = {
              cssConflict = "warning",
              invalidApply = "error",
              invalidScreen = "error",
              invalidVariant = "error",
              invalidConfigPath = "error",
              recommendedVariantOrder = "warning",
              invalidClass = "error",
              invalidTailwindDirective = "error",
            },
            validate = true,
            hovers = true,
            completion = {
              autoRequire = true,
              triggerType = "auto",
            },
            editor = {
              quickSuggestions = {
                other = true,
                comments = false,
                strings = true,
              },
              suggestOnCommitCharacters = true,
              acceptSuggestionOnCommitCharacter = true,
              snippetSuggestions = "inline",
              tabCompletion = "on",
              formatOnType = true,
              wordBasedSuggestions = true,
              parameterHints = {
                enabled = true,
              },
            },
          },
        },
      },
      -- Configuración de treesitter
      treesitter_integration = {
        enabled = true,
        parsers = {
          "html",
          "css",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "vue",
          "svelte",
          "astro",
        },
      },
    })

    -- Keymaps específicos para Tailwind
    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Tailwind specific keymaps
    keymap("n", "<leader>tc", "<cmd>TailwindClassSort<CR>", opts) -- Sort classes
    keymap("n", "<leader>ts", "<cmd>TailwindSortSelection<CR>", opts) -- Sort selection
    keymap("n", "<leader>tr", "<cmd>TailwindRemoveClasses<CR>", opts) -- Remove classes
    keymap("n", "<leader>ta", "<cmd>TailwindConceal<CR>", opts) -- Toggle conceal
    keymap("n", "<leader>th", "<cmd>TailwindHide<CR>", opts) -- Hide classes
    keymap("n", "<leader>tH", "<cmd>TailwindShow<CR>", opts) -- Show classes
    keymap("n", "<leader>tt", "<cmd>TailwindToggleClass<CR>", opts) -- Toggle class
    keymap("n", "<leader>tf", "<cmd>TailwindFindConfig<CR>", opts) -- Find config
    keymap("n", "<leader>tC", "<cmd>TailwindConfigure<CR>", opts) -- Configure
    keymap("n", "<leader>tl", "<cmd>TailwindLog<CR>", opts) -- Log
    keymap("n", "<leader>tR", "<cmd>TailwindRestart<CR>", opts) -- Restart LSP

    -- Visual mode keymaps
    keymap("v", "<leader>ts", "<cmd>TailwindSortSelection<CR>", opts) -- Sort selection
    keymap("v", "<leader>tr", "<cmd>TailwindRemoveSelection<CR>", opts) -- Remove selection
    keymap("v", "<leader>tw", "<cmd>TailwindWrapSelection<CR>", opts) -- Wrap selection

    -- Comandos útiles
    vim.api.nvim_create_user_command("TailwindSort", function()
      vim.cmd("TailwindClassSort")
    end, {
      desc = "Sort Tailwind classes in current buffer",
    })

    vim.api.nvim_create_user_command("TailwindSortAll", function()
      local buffers = vim.api.nvim_list_bufs()
      for _, buf in ipairs(buffers) do
        local ft = vim.api.nvim_buf_get_option(buf, "filetype")
        if vim.tbl_contains({
          "html", "css", "javascript", "typescript", 
          "javascriptreact", "typescriptreact", "vue", "svelte", "astro"
        }, ft) then
          vim.api.nvim_buf_call(buf, function()
            vim.cmd("TailwindClassSort")
          end)
        end
      end
      vim.notify("Tailwind classes sorted in all buffers", vim.log.levels.INFO)
    end, {
      desc = "Sort Tailwind classes in all buffers",
    })

    vim.api.nvim_create_user_command("TailwindConfig", function()
      local config = vim.fn.findfile("tailwind.config.js", ".;")
      if config == "" then
        config = vim.fn.findfile("tailwind.config.ts", ".;")
      end
      if config == "" then
        config = vim.fn.findfile("tailwind.config.mjs", ".;")
      end
      if config == "" then
        vim.notify("No Tailwind config found", vim.log.levels.WARN)
        return
      end
      vim.cmd("edit " .. config)
    end, {
      desc = "Open Tailwind config file",
    })

    vim.api.nvim_create_user_command("TailwindBuild", function()
      vim.cmd("!npm run build")
    end, {
      desc = "Build Tailwind CSS",
    })

    vim.api.nvim_create_user_command("TailwindWatch", function()
      vim.cmd("!npm run dev")
    end, {
      desc = "Watch Tailwind CSS",
    })

    -- Autocommandos para Tailwind
    vim.api.nvim_create_augroup("TailwindTools", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = "TailwindTools",
      pattern = { "*.html", "*.css", "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue", "*.svelte", "*.astro" },
      callback = function()
        -- Auto-sort classes on save (opcional)
        -- vim.cmd("TailwindClassSort")
      end,
    })

    -- Configuración de highlights para Tailwind
    vim.api.nvim_set_hl(0, "TailwindClass", { fg = "#89b4fa", bold = true })
    vim.api.nvim_set_hl(0, "TailwindColor", { fg = "#f9e2af" })
    vim.api.nvim_set_hl(0, "TailwindScreen", { fg = "#a6e3a1" })
    vim.api.nvim_set_hl(0, "TailwindVariant", { fg = "#cba6f7" })
    vim.api.nvim_set_hl(0, "TailwindState", { fg = "#f38ba8" })
    vim.api.nvim_set_hl(0, "TailwindUtility", { fg = "#74c7ec" })

    -- Integración con CMP
    local cmp = require("cmp")
    cmp.setup.filetype({
      "html", "css", "javascript", "typescript", 
      "javascriptreact", "typescriptreact", "vue", "svelte", "astro"
    }, {
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "tailwindcss" },
      }),
    })
  end,
}
