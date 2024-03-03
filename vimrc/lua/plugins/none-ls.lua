-- plugin: none-ls.nvim
-- see: https://github.com/nvimtools/none-ls.nvim

local M = {}

local function has_exec(filename)
  return function(_)
    return vim.fn.executable(filename) == 1
  end
end

function M.setup()
  local builtins = require('null-ls').builtins
  require('null-ls').setup({
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
        runtime_condition = has_exec('vint'),
      }),

      -- Markdown
      builtins.diagnostics.markdownlint.with({
        runtime_condition = has_exec('markdownlint'),
        extra_filetypes = { 'vimwiki' },
      }),
      builtins.diagnostics.proselint.with({
        runtime_condition = has_exec('proselint'),
        extra_filetypes = { 'vimwiki' },
      }),
    },
  })
end

return M
