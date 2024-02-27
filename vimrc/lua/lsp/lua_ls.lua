-- lua_ls language sever settings
---------------------------------

local M = {}

function M.config(_)
  return {
    Lua = {
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
        },
      },
    },
  }
end

return M
