-- badge.lua
------------

local core = require('core')

vim.api.nvim_exec([[
augroup badge_lua_cache
	autocmd!
	autocmd BufWritePre,FileChangedShellPost,TextChanged,InsertLeave *
        \ unlet! b:badge_cache_trails
	autocmd BufReadPost,BufFilePost,BufNewFile,BufWritePost *
        \ call v:lua.badge_clear_cache()
augroup END
]], false)

local badge_caches = {}

-- Special filetype
local special_filetype_icons = {
  vfiler          = {icon = '', name = 'vfiler'},
  undotree        = {icon = '', name = 'undotree'},
  qf              = {icon = '', name = 'List'},
  TelescopePrompt = {icon = '', name = 'Telescope'},
  Trouble         = {icon = '', name = 'Trouble'},
  DiffviewFiles   = {icon = '', name = 'DiffviewFiles'},
  Outline         = {icon = '', name = 'Outline'},
  NeogitStatus    = {icon = '', name = 'NeogitStatus'},
  ['mason.nvim']  = {icon = '', name = 'Mason'},
  spectre_panel   = {icon = '', name = 'Spectre'},
}

function _G.badge_clear_cache()
  -- Clear icon cache
  pcall(vim.api.nvim_buf_del_var, 0, 'badge_cache_icon')

  -- Claer filepath caches
  for _, cache in ipairs(badge_caches) do
    pcall(vim.api.nvim_buf_del_var, 0, cache)
  end
  badge_caches = {}
end

local M = {}

function M.filepath(bufnr, max_dirs, dir_max_chars)
  local name = vim.api.nvim_buf_get_name(bufnr)

  -- User buffer's cached filepath
  local cache_key = ('badge_cache_%s_filepath'):format(
    vim.bo.filetype:lower():gsub('[^a-z]', '_')
  )

  local ok, cache = pcall(vim.api.nvim_buf_get_var, bufnr, cache_key)
  if ok then
    return cache
  elseif #name < 1 then
    return 'N/A'
  end
  name = core.normalize_path(name)

  local parts = vim.split(name, '/', {})
  local dirs = {}
  while #parts > 1 do
    local dir = table.remove(parts, 1)
    if #parts <= max_dirs then
      table.insert(dirs, dir:sub(1, dir_max_chars))
    end
  end
  local path = table.concat(dirs, '/')
  if #dirs > 0 then
    path = path .. '/'
  end
  path = path .. parts[1]

  vim.api.nvim_buf_set_var(bufnr, cache_key, path)
  if not vim.tbl_contains(badge_caches, cache_key) then
    table.insert(badge_caches, cache_key)
  end
  return path
end

function M.filemode(normal_symbol, readonly_symbol, zoom_symbol)
  local mode = ''
  if not (vim.bo.readonly or vim.t.zoomed) then
    mode = mode .. normal_symbol
  end
  if vim.bo.readonly then
    mode = mode .. readonly_symbol
  end
  if vim.t.zoomed then
    mode = mode .. zoom_symbol
  end
  return mode
end

function M.modified(symbol)
  return vim.bo.modified and symbol or ''
end

function M.icon_data(bufnr)
  local cache_key = 'badge_cache_icon'
  local cache_ok, cache = pcall(vim.api.nvim_buf_get_var, bufnr, cache_key)
  if cache_ok then
    return cache
  end

  local devicon_ok, devicons = pcall(require, 'nvim-web-devicons')
  if not devicon_ok then
    -- If not installed, returns default icon
    return {icon = '', color = '#6d8086'}
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  local icon, color, _ = devicons.get_icon_colors(
    vim.fn.fnamemodify(name, ':t:r'), vim.fn.fnamemodify(name, ':e'),
    {default = true}
  )
  local data = {icon = icon, color = color}
  vim.api.nvim_buf_set_var(bufnr, cache_key, data)
  return data
end

-- Detect trailing whitespace and cache result per buffer
function M.trails(symbol)
  local cache_key = 'badge_cache_trails'
  local ok, cache = pcall(vim.api.nvim_buf_get_var, 0, cache_key)
  if ok then
    return cache
  end

  local trails = ''
  if not vim.bo.readonly and vim.bo.modified and vim.fn.line('$') < 9000 then
    local trailing = vim.fn.search('\\s$', 'nw')
    if trailing > 0 then
      local label = symbol or 'WS:'
      trails = trails .. label .. trailing
    end
  end
  vim.api.nvim_buf_set_var(0, cache_key, trails)
  return trails
end

function M.lsp_server()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({bufnr = bufnr})
  if #clients == 0 then
    return '[No Active Lsp]'
  end
  return clients[1].name
end

function M.progress()
  local lcount = vim.api.nvim_buf_line_count(0)
  local digit = 0
  repeat
    digit = digit + 1
    lcount = math.floor(lcount / 10)
  until lcount <= 0
  return (' %%%dl  %%2c│%%3p%%%%'):format(digit)
end

-- Try to guess the project's name
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

function M.session(symbol)
  return vim.v.this_session and symbol or ''
end

function M.special_name(bufnr)
  local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  local sp_icon = special_filetype_icons[filetype]
  if not sp_icon then
    return nil
  end
  return sp_icon.icon .. ' ' .. sp_icon.name
end

return M
