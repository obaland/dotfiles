-- lua_ls language sever settings
---------------------------------

local M = {}

function M.config(options)
  options.Lua = {
    runtime = {
      version = 'LuaJIT',
      path = vim.fn.split(package.path, ';'),
    },
    diagnostics = {
      enable = true,
      globals = {
        'vim',
        'use',
        'describe',
        'it',
        'assert',
        'before_each',
        'after_each',
      },
    },
    workspace = {
      library = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        [vim.fn.expand('$CONFIG_PATH/dein')] = true,
      },
    },
  }
  return options
end

return M
