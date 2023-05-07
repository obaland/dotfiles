-- plugin: null-ls.nvim
-- see: https://github.com/jose-elias-alvarez/null-ls.nvim

local M = {}

local function has_exec(filename)
  return function(_)
    return vim.fn.executable(filename) == 1
  end
end

function M.setup()
  local builtins = require('null-ls').builtins
  local on_attach = require('plugins/lspconfig').on_attach

  require('null-ls').setup({
    -- Ensure key maps are setup
    on_attach = on_attach,

    sources = {
      -- Whitespace
      builtins.diagnostics.trail_space.with({
        disabled_filetype = { 'gitcommit' },
      }),

      -- Ansible
      builtins.diagnostics.ansiblelint.with({
        runtime_condition = has_exec('ansible-lint'),
        extra_filetypes = { 'yaml', 'yaml.ansible' },
      }),

      -- Javascript
      builtins.diagnostics.eslint,

      builtins.formatting.gofmt.with({
        runtime_condition = has_exec('gofmt'),
      }),
      builtins.formatting.gofmt.with({
        runtime_condition = has_exec('gofumpt'),
      }),
      builtins.formatting.gofmt.with({
        runtime_condition = has_exec('golines'),
      }),

      -- Lua
      builtins.formatting.stylua,

      -- SQL
      builtins.formatting.sqlformat,

      -- Shell
      builtins.diagnostics.shellcheck.with({
        runtime_condition = has_exec('shellcheck'),
        extra_filetypes = { 'bash' },
      }),
      builtins.diagnostics.shellcheck.with({
        runtime_condition = has_exec('shfmt'),
        extra_filetypes = { 'bash' },
      }),
      builtins.diagnostics.shellcheck.with({
        runtime_condition = has_exec('shellharden'),
        extra_filetypes = { 'bash' },
      }),

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
