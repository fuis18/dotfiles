local tsdk = LazyVim.get_pkg_path(
  "vtsls",
  "/node_modules/@vtsls/language-server/node_modules/typescript/lib"
)

local function with_tsdk(server)
  server.init_options = vim.tbl_deep_extend("force", server.init_options or {}, {
    typescript = {
      tsdk = tsdk,
    },
  })
  return server
end

local function valid_tsdk(path)
  if path == "" or not path then
    return false
  end
  for _, file in ipairs({ "typescript.js", "tsserverlibrary.js", "tsserver.js" }) do
    if vim.uv.fs_stat(path .. "/" .. file) then
      return true
    end
  end
  return false
end

LazyVim.on_very_lazy(function()
  vim.lsp.config("astro", {
    before_init = function(_, config)
      config.init_options = config.init_options or {}
      config.init_options.typescript = config.init_options.typescript or {}
      local util = require("lspconfig.util")
      local ws_tsdk = config.root_dir and util.get_typescript_server_path(config.root_dir) or ""
      config.init_options.typescript.tsdk = (valid_tsdk(ws_tsdk) and ws_tsdk)
        or (valid_tsdk(config.init_options.typescript.tsdk) and config.init_options.typescript.tsdk)
        or tsdk
    end,
  })
end)

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      for _, name in ipairs({ "vtsls", "astro", "svelte", "vue_ls" }) do
        opts.servers[name] = with_tsdk(opts.servers[name])
      end
    end,
  },
}
