-- lua_ls language sever settings
---------------------------------

local M = {}

function M.make_config(options)
  options.settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        enable = true,
        globals = {
          'vim',
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.fn.expand('$VIMRUNTIME/lua'),
          vim.fn.expand('$VIMRUNTIME/lua/vim/lsp'),
          '${3rd}/luv/library',
          '${3rd}/busted/library',
          '${3rd}/luassert/library',
          unpack(vim.api.nvim_get_runtime_file('', true)),
        },
      },
    },
  }
  return options
end

return M
