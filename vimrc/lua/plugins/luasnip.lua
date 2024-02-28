-- plugin: LuaSnip
-- see: https://github.com/L3MON4D3/LuaSnip

local M = {}

function M.setup()
  local luasnip = require('luasnip')
  luasnip.config.set_config({
    history = true,
    updateevents = 'TextChanged,TextChangedI',
  })

  -- vscode format
  local from_vscode = require('luasnip/loaders/from_vscode')
  from_vscode.lazy_load()
  from_vscode.lazy_load({ paths = vim.g.vscode_snippets_path or '' })

  -- snipmate format
  local from_snipmate = require('luasnip/loaders/from_snipmate')
  from_snipmate.load()
  from_snipmate.lazy_load({ paths = vim.g.snipmate_snippets_path or '' })

  -- lua format
  local from_lua = require('luasnip/loaders/from_lua')
  from_lua.load()
  from_lua.lazy_load({ paths = vim.g.lua_snippets_path or '' })

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
