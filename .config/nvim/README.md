# Configuración de Neovim

Gestor de plugins: [lazy.nvim](https://github.com/folke/lazy.nvim)

## Plugins

| Plugin | Descripción |
|--------|-------------|
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | Tema Catppuccin (flavor mocha) con integraciones |
| [nyoom-engineering/oxocarbon.nvim](https://github.com/nyoom-engineering/oxocarbon.nvim) | Tema alternativo Oxocarbon |
| [lukas-reineke/indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | Líneas de indentación con resaltado de scope |
| [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Barra de estado con información de git, LSP y diagnóstico |
| [nvimdev/dashboard-nvim](https://github.com/nvimdev/dashboard-nvim) | Pantalla de inicio con logo ASCII y accesos directos |
| [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | Iconos por tipo de archivo |
| [nvim-neo-tree/neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | Explorador de archivos con git status y buffers |
| [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Buscador fuzzy (archivos, grep, buffers, ayuda) |
| [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Resaltado de sintaxis, indentación y textobjects |
| [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim) | Gestor de paquetes para LSP, linters y formatters |
| [WhoIsSethDaniel/mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) | Instalación automática de herramientas via Mason |
| [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | Configuración de servidores LSP |
| [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Motor de autocompletado con múltiples fuentes |
| [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Motor de snippets |
| [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | Colección de snippets predefinidos |
| [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim) | Formateo de código al guardar |
| [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Indicadores de git en la columna de signos |
| [mrcjkb/rustaceanvim](https://github.com/mrcjkb/rustaceanvim) | Herramientas IDE para Rust (runnables, debug, test) |
| [saecki/crates.nvim](https://github.com/saecki/crates.nvim) | Gestión de versiones de crates en Cargo.toml |
| [luckasRanarison/tailwind-tools.nvim](https://github.com/luckasRanarison/tailwind-tools.nvim) | Herramientas para Tailwind CSS (sort, color preview) |
| [MeanderingProgrammer/render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Renderizado de Markdown en buffers |
| [Betelgeuse1/zealua.nvim](https://github.com/Betelgeuse1/zealua.nvim) | Integración con Zeal documentation browser |
| [b0o/schemastore.nvim](https://github.com/b0o/schemastore.nvim) | Esquemas JSON/YAML para jsonls/yamlls |

## LSP Servers

| Servidor | Lenguaje |
|----------|----------|
| `lua_ls` | Lua |
| `ts_ls` | TypeScript, JavaScript |
| `html` | HTML |
| `cssls` | CSS |
| `tailwindcss` | Tailwind CSS |
| `jsonls` | JSON |
| `yamlls` | YAML |
| `pyright` | Python |
| `clangd` | C, C++ |
| `bashls` | Bash, Zsh |
| `sqls` | SQL |
| `prismals` | Prisma |
| `graphql_lsp` | GraphQL |
| `svelte` | Svelte |
| `dockerls` | Docker |
| `rust_analyzer` | Rust (via rustaceanvim) |

## Atajos de teclado

### Generales
- `<Space>` — líder
- `<C-h/j/k/l>` — navegación entre ventanas
- `<Tab>` / `<S-Tab>` — siguiente/anterior buffer

### Telescope
- `<leader>ff` — buscar archivos
- `<leader>fg` — live grep
- `<leader>fb` — buffers
- `<leader>fh` — ayuda
- `<leader>th` — cambiar tema (catppuccin/oxocarbon)

### LSP
- `gd` — ir a definición
- `K` — hover
- `gr` — referencias
- `<leader>rn` — renombrar
- `<leader>ca` — code action
- `[d` / `]d` — diagnóstico anterior/siguiente

### Rust
- `<leader>rr` — runnables
- `<leader>rd` — debuggables
- `<leader>rt` — testables
- `<leader>re` — expandir macro
- `<leader>rg` — grafo de dependencias

### Tailwind CSS
- `<leader>tc` — ordenar clases
- `<leader>th` / `<leader>tH` — ocultar/mostrar panel

### Otros
- `<leader>e` — toggle neo-tree
- `<leader>E` — revelar archivo actual en neo-tree
- `<leader>f` — formatear código
- `<leader>z` — buscar documentación en Zeal
- `<leader>cu` — actualizar crate
- `<leader>ca` — actualizar todos los crates

## Formateo

Ejecutado al guardar via conform.nvim:

| Lenguaje | Formateador |
|----------|-------------|
| Lua | `stylua` |
| Python | `black`, `isort` |
| Rust | `rustfmt` |
| JS/TS/CSS/HTML/JSON/YAML/Markdown | `prettierd` / `prettier` |
| Shell | `shfmt` |
| Go | `goimports`, `gofmt` |
| Fish | `fish_indent` |
