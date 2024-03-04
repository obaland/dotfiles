-- plugin: none-ls.nvim
-- see: https://github.com/nvimtools/none-ls.nvim

local core = require('core')

local M = {}

local function has_exec(filename)
  return vim.fn.executable(filename) == 1
end

local function hook_has_exec(filename)
  return function(_)
    return has_exec(filename)
  end
end

function M.setup()
  local builtins = require('null-ls').builtins
  require('null-ls').setup({
    should_attach = function(_)
      -- Exclude buffers in `vfiler.vim`
      return vim.bo.filetype ~= 'vfiler'
    end,

    sources = {
      -- Whitespace
      builtins.diagnostics.trail_space.with({
        disabled_filetype = { 'gitcommit' },
      }),

      -- Lua
      builtins.formatting.stylua,

      -- SQL
      builtins.formatting.sqlformat,

      -- Vim
      builtins.diagnostics.vint.with({
        runtime_condition = function(_)
          return has_exec('vint') and (not core.is_win())
        end,
      }),

      -- Markdown
      builtins.diagnostics.markdownlint.with({
        runtime_condition = hook_has_exec('markdownlint'),
        extra_filetypes = { 'vimwiki' },
      }),
      builtins.diagnostics.proselint.with({
        runtime_condition = hook_has_exec('proselint'),
        extra_filetypes = { 'vimwiki' },
      }),
    },
  })
end

return M
