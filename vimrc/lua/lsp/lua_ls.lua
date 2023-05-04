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

      telemetry = {
        enable = false,
      },
    },
  }
end

return M
