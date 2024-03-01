-- plugin: LuaSnip
-- see: https://github.com/L3MON4D3/LuaSnip

local M = {}

function M.setup()
  local luasnip = require('luasnip')
  luasnip.config.set_config({
    history = true,
    updateevents = 'TextChanged,TextChangedI',
  })

  vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      if luasnip.session.current_nodes[bufnr] and not luasnip.session.jump_active then
        luasnip.unlink_current()
      end
    end
  })
end

return M
