local core = require('core')

local M = {}

function M.setup()
  require('heirline').setup({
    statusline = require('plugins/heirline/statusline').components(),
    winbar = require('plugins/heirline/winbar').components(),
    opts = {
      colors = core.get_colors(),
      disable_winbar_cb = function(args)
        local clients = vim.lsp.get_active_clients({ bufnr = args.buf })
        return #clients == 0 or clients[1].name == 'null-ls'
      end,
    },
  })
end

return M
