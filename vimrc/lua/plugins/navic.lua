-- plugin: navic.nvim
-- see: https://github.com/SmiteshP/nvim-navic

local ok, navic = pcall(require, 'nvim-navic')

local M = {}

function M.setup()
  if not ok then
    return
  end

  navic.setup {
    highlight = true,
  }
end

function M.get_location()
  if not ok then
    return ''
  end
  return navic.get_location()
end

function M.is_available()
  if not ok then
    return false
  end
  return navic.is_available()
end

return M
