-- core.lua
-----------

-- stylua: ignore start
local project_root_patterns = {
  ['.git']    = {is_dir = false},
  ['.git/']   = {is_dir = true},
  ['_darcs/'] = {is_dir = true},
  ['.hg/']    = {is_dir = true},
  ['.bzr/']   = {is_dir = true},
  ['.svn/']   = {is_dir = true},
  ['.vs/']    = {is_dir = true},
}

-- NOTE: vim compatibility
local command = vim.fn.has('nvim') and vim.cmd or vim.command
command(
  [[
    augroup user_cache
      autocmd!
      autocmd BufReadPost,BufFilePost,BufNewFile,BufWritePost * unlet! b:core_project_dir | unlet! b:core_project_dir_last_cwd
    augroup END
  ]]
)
-- stylua: ignore end

local M = {}

-- Vim script functions
local is_win = vim.fn['core#is_windows']
local is_mac = vim.fn['core#is_mac']

local function find(name, dir, comp)
  -- NOTE: vim compatibility
  local names = vim.fn.split(M.normalize_path(dir), '/')
  while #names > 0 do
    local current = table.concat(names, '/')
    if not M.is_win() then
      current = '/' .. current
    end
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
  -- NOTE: vim compatibility
  local exists = vim.fn.exists('b:core_project_dir')
    and vim.fn.exists('b:core_project_dir_last_cwd')
  local last_cwd = vim.fn.getbufvar(bufnr, 'core_project_dir_last_cwd')
  if exists and last_cwd == cwd then
    return vim.fn.getbufvar(bufnr, 'core_project_dir')
  end

  local dir = ''
  for pattern, property in pairs(project_root_patterns) do
    local fn_find = property.is_dir and finddir or findfile
    dir = fn_find(pattern, cwd)
    if #dir > 0 then
      vim.fn.setbufvar(bufnr, 'core_project_dir', dir)
      vim.fn.setbufvar(bufnr, 'core_project_dir_last_cwd', cwd)
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
  return project_root(bufnr, vim.fn.fnamemodify(bufname, ':p:h'))
end

-- Get icon from "vfiler-column-devicons"
function M.get_icon(filename)
  -- Load vfiler-column-devicons
  local exists, devicons = pcall(require, 'vfiler/columns/devicons')
  if not (exists and devicons) then
    -- If not installed, returns default icon
    return '', '#6d8086'
  end
  return devicons.get_icon_color(filename)
end

-- API
--============================================================================
M.api = {}

-- LSP attach function using `LspAttach` event
function M.api.on_lsp_attach(callback, group)
  vim.api.nvim_create_autocmd('LspAttach', {
    group = group,
    callback = function(ev)
      callback(vim.lsp.get_client_by_id(ev.data.client_id), ev.buf)
    end,
  })
end

return M
