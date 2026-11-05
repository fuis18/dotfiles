return {
  {
    "snacks.nvim",
    opts = {
      image = {
        enabled = true,
      },
    },
    init = function()
      local ok, inline = pcall(require, "snacks.image.inline")
      if not ok then
        return
      end

      local instances = {}
      local orig_new = inline.new
      inline.new = function(buf)
        local self = orig_new(buf)
        instances[buf] = self
        local group = vim.api.nvim_create_augroup(("snacks.image.mermaid.%d"):format(buf), { clear = true })
        vim.api.nvim_create_autocmd({ "ModeChanged", "CursorMoved" }, {
          group = group,
          buffer = buf,
          callback = function()
            local inst = instances[buf]
            if not inst then
              return
            end
            local mode = vim.fn.mode():sub(1, 1):lower()
            local selecting = mode == "v" or mode == "\22" or mode == "s" or mode == "\19"
            if vim.wo.concealcursor:find(mode) then
              selecting = false
            end
            for _, img in pairs(inst.imgs) do
              if img.opts and img.opts.type == "chart" then
                if selecting then
                  img:hide()
                else
                  img:show()
                end
              end
            end
          end,
        })
        return self
      end
    end,
  },
}
