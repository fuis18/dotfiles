return {
  "SmiteshP/nvim-navic",
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("nvim-navic", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
          require("nvim-navic").attach(client, args.buf)
        end
      end,
    })
  end,
}
