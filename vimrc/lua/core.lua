-- core.lua
-----------

local project_root_patterns = {
  ['.git']    = {is_dir = false},
  ['.git/']   = {is_dir = true},
  ['_darcs/'] = {is_dir = true},
  ['.hg/']    = {is_dir = true},
  ['.bzr/']   = {is_dir = true},
  ['.svn/']   = {is_dir = true},
}

vim.api.nvim_exec([[
augroup core_lua_cache
	autocmd!
	autocmd BufReadPost,BufFilePost,BufNewFile,BufWritePost *
        \ unlet! b:core_project_dir |
        \ unlet! b:core_project_dir_last_cwd
augroup END
]], false)

-- Color table based on "solarized dark"
local colors = {
  base03    = '#002b36',
  base02    = '#073642',
  base01    = '#586e75',
  base00    = '#657b83',
  base0     = '#839496',
  base1     = '#93a1a1',
  base2     = '#eee8d5',
  base3     = '#fdf6e3',
  yellow    = '#b58900',
  orange    = '#cb4b16',
  red       = '#dc322f',
  magenta   = '#d33682',
  violet    = '#6c71c4',
  blue      = '#268bd2',
  cyan      = '#2aa198',
  green     = '#859900',
  olivedrab = '#6b8e23',
  rosefenicottero = '#f0435a',
  soft_blue = '#5faeec',
  soft_red  = '#ec5f67',
  grayish_yellow = '#d7d7bc',
}

local M = {}

-- Vim script functions
local is_win = vim.fn['IsWindows']
local is_mac = vim.fn['IsMac']

local function find(name, dir, comp)
  local names = vim.split(
    M.normalize_path(dir), '/', {plain = true, trimempty = true}
  )
  while #names > 0 do
    local current = table.concat(names, '/')
    if comp(current .. '/' .. name) == 1 then
      return current
    end
    table.remove(names)
  end
  return ''
end

local function finddir(name, dir)
  return find(name, dir, vim.fn.isdirectory)
end

local function findfile(name, dir)
  return find(name, dir, vim.fn.filereadable)
end

local function project_root(bufnr, cwd)
  local dir_ok, dir = pcall(
    vim.api.nvim_buf_get_var, bufnr, 'core_project_dir'
  )
  local dir_last_cwd_ok, dir_last_cwd = pcall(
    vim.api.nvim_buf_get_var, bufnr, 'core_project_dir_last_cwd'
  )
  if (dir_ok and dir_last_cwd_ok) and dir_last_cwd == cwd then
    return dir
  end

  dir = ''
  for pattern, property in pairs(project_root_patterns) do
    local fn_find = property.is_dir and finddir or findfile
    dir = fn_find(pattern, cwd)
    if #dir > 0 then
      vim.api.nvim_buf_set_var(bufnr, 'core_project_dir', dir)
      vim.api.nvim_buf_set_var(bufnr, 'core_project_dir_last_cwd', cwd)
      return dir
    end
  end
  return dir
end

function M.is_mac()
  return is_mac() == 1
end

function M.is_win()
  return is_win() == 1
end

function M.normalize_path(path)
  if M.is_win() then
    return path:gsub('\\', '/')
  end
  return path
end

-- Find the root directory by searching for the version-control dir
function M.project_root(bufnr)
  return project_root(bufnr, vim.fn.getcwd())
end

-- From the current buffer, find the root directory by searching for
-- the version-control dir
function M.project_root_bufname(bufnr)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if vim.fn.filereadable(bufname) ~= 1 then
    return M.project_root(bufnr)
  end
  return project_root(
    bufnr, vim.fn.fnamemodify(bufname, ':p:h')
  )
end

-- Get color table
function M.get_colors()
  return colors
end

-- Get icon from "nvim-web-devicons"
function M.get_icon(filename)
  -- Load nvim-web-devicons
  local exists, devicons = pcall(require, 'nvim-web-devicons')
  if not exists then
    -- If not installed, returns default icon
    return '', '#6d8086'
  end
  local extension = vim.fn.fnamemodify(filename, ':e')
  return devicons.get_icon_color(filename, extension, { default = true })
end

return M
