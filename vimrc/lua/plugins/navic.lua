-- plugin: nvim-navic
-- see: https://github.com/SmiteshP/nvim-navic

local M = {}

function M.setup()
  require('nvim-navic').setup({
    highlight = true,
  })
end

return M
