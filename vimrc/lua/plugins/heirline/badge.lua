local core = require('core')
local conditions = require('heirline/conditions')

local M = {}

function M.normalize_path(filename)
  local name = vim.fn.fnamemodify(filename, ':.')
  if name == '' then
    return '[No Name]'
  end
  -- now, if the filename would occupy more than 1/4th of the available
  -- space, we trim the file path to its initials
  -- See Flexible Components section below for dynamic truncation
  if not conditions.width_percent_below(#name, 0.25) then
    name = vim.fn.pathshorten(name)
  end
  return core.normalize_path(name)
end

function M.project()
  local dir = core.project_root(0)
  local icon = ''
  if #dir > 0 then
    icon = ' '
  else
    dir = vim.fn.getcwd()
  end
  return icon .. vim.fn.fnamemodify(dir, ':t')
end

return M
