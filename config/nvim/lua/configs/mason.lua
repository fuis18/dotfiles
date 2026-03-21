-- nvim/lua/configs/mason.lua

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

return {
	ensure_installed = vim.list_extend({
		-- LSP
		"lua-language-server",
    "typescript-language-server",
    "tailwindcss-language-server",
    "html-lsp",
    "css-lsp",
    "json-lsp",
    "eslint-lsp",
    "astro-language-server",
    "prisma-language-server",
    "rust-analyzer",
    "markdown-oxide",
		-- Formatters
		"stylua",
		"prettier",
	},
	--"omnisharp", Only if required
	vim.fn.has("unix") == 1 and {
		"rust-analyzer",
	} or {}),
	max_concurrent_installers = 10,
}
