-- plugin: todo-comments.nvim
-- see: https://github.com/folke/todo-comments.nvim

local M = {}

function M.setup()
  require('todo-comments').setup({
    signs = false,
    colors = {
      error =   {'#968583'},
      info =    {'#789DA1'},
      hint =    {'#8B9683'},
      default = {'#6CA6AD'}
    },
  })
end

return M
