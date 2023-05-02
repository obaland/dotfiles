local conditions = require('heirline/conditions')

local M = {}

local function get_lsp_servername()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  if #clients == 0 then
    return '[No Active Lsp]'
  end
  return clients[1].name
end

function M.components()
  return {
    init = function(self)
      local bufnr = vim.api.nvim_get_current_buf()
      local clients =  vim.lsp.get_active_clients({ bufnr = bufnr })
      self.servername = (#clients ~= 0) and clients[1].name or ''
    end,
    condition = function(self)
      return self.servername ~= ''
    end,
    {
      provider = function(self)
        local name = self.servername
        if name == '' then
          name = '[No Active Lsp]'
        end
        return '  ' .. name
      end,
      hl = 'WinbarLspClientName',
    },
  }
end

return M
