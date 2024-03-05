-- plugin: none-ls.nvim
-- see: https://github.com/nvimtools/none-ls.nvim

local core = require('core')

local M = {}

-- List of file types to ignore `none-ls`.
local ignore_filetypes = {
  vfiler = true,
}

local function has_exec(filename)
  return vim.fn.executable(filename) == 1
end

local function hook_has_exec(filename)
  return function(_)
    return has_exec(filename)
  end
end

function M.setup()
  local configs_dir = core.normalize_path(
    vim.env.VIM_CONFIGS_PATH .. '/none-ls'
  )
  local builtins = require('null-ls').builtins

  require('null-ls').setup({
    should_attach = function(bufnr)
      local filetype = vim.bo[bufnr].filetype
      return not ignore_filetypes[filetype]
    end,

    sources = {
      -- Whitespace
      builtins.diagnostics.trail_space.with({
        disabled_filetype = { 'gitcommit' },
      }),

      -- Lua
      builtins.formatting.stylua,
      builtins.diagnostics.selene.with({
        runtime_condition = hook_has_exec('selene'),
        extra_args = { '--config', configs_dir .. '/selene.toml' },
      }),

      -- SQL
      builtins.formatting.sqlformat,

      -- Vim
      builtins.diagnostics.vint.with({
        runtime_condition = hook_has_exec('vint'),
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
