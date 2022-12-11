-- tabline.lua
--------------

local badge = require('badge')

-- Configuration

-- U+2590 ▐ Right half block, this character is right aligned so the
-- background highlight doesn't appear in the middle
-- alternatives:  right aligned => ▕ ▐ ,  left aligned => ▍
local indicator = '▍'

-- Maximum number of directories in filepath
local badge_tabline_filepath_max_dirs = 0

-- Maximum number of characters in each directory
local badge_tabline_dir_max_chars = 5

-- ['₀','₁','₂','₃','₄','₅','₆','₇','₈','₉'])
local numeric_charset = {'⁰','¹','²','³','⁴','⁵','⁶','⁷','⁸','⁹'}

local function is_file_buffer(bufnr)
  local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
  return #buftype == 0
end

local function numtr(number)
  -- NOTE: Up to 2 digits
  if number < 10 then
    return numeric_charset[number + 1]
  end
  local digit10 = math.floor(number / 10)
  local digit1 = number % 10
  return numeric_charset[digit10 + 1] .. numeric_charset[digit1 + 1]
end

local function filename(bufnr)
  local name = badge.special_name(bufnr)
  if name then
    return name
  end
  local icon_data = badge.icon_data(bufnr)
  return icon_data.icon .. ' ' .. badge.filepath(
    bufnr,
    badge_tabline_filepath_max_dirs,
    badge_tabline_dir_max_chars
  )
end

-- Global functions

function _G.tabline()
  if vim.g.SessionLoad then
    -- Skip tabline render during session loading
    return ''
  end

  -- Active project name
  local tabparts = {
    '%#TabLineAlt# ' .. badge.project() .. ' %#TabLineAltShade#'
  }

  -- Iterate through all tabs and collect labels
  --local current = vim.fn.tabpagenr()
  local current = vim.api.nvim_get_current_tabpage()
  for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
    local win = vim.api.nvim_tabpage_get_win(tabpage)
    local bufnr = vim.api.nvim_win_get_buf(win)
    local part = ''

    -- Left-side of single tab
    if tabpage == current then
      part = '%#TabLineSepSel#' .. indicator .. '%#TabLineSel#' .. numtr(tabpage)
    else
      part = '%#TabLineSep#' .. indicator .. '%#TabLine#' .. numtr(tabpage)
    end
    table.insert(tabparts, part)

    -- Get file-name with custom cutoff settings
    table.insert(tabparts, ('%%%sT%s'):format(tabpage, filename(bufnr)))

    -- Add '+' if one of the buffers in the tab page is modified
    local modified = vim.api.nvim_buf_get_option(bufnr, 'modified')
    if modified and is_file_buffer(bufnr) then
      if tabpage == current then
        table.insert(tabparts, '%#Number#')
      end
      table.insert(tabparts, ' ●')
    end

    -- Right-side of single tab
    if tabpage == current then
      part = '%#TabLineSel# %#TabLine#'
    else
      part = '%#TabLine# '
    end
    table.insert(tabparts, part)
  end

  -- Empty elastic space and session indicator
  table.insert(tabparts, '%#TabLineFill#%T%#TabLine#')
  local ok, session = pcall(vim.api.nvim_get_vvar, 'this_session')
  if ok and #session > 0 then
    local session_name = vim.fn.tr(session, '%', '/')
    table.insert(tabparts, vim.fn.fnamemodify(session_name, ':t:r') .. '  ')
  end

  return table.concat(tabparts)
end

local M = {}

function M.setup()
  vim.api.nvim_set_option('tabline', '%!v:lua.tabline()')
end

return M
