-- plugin: goto-preview
-- see: https://github.com/rmagatti/goto-preview

local M = {}

function M.setup()
  require('goto-preview').setup({
    -- debug = false,
    width = 78,
    height = 15,
    opacity = 10,
    default_mappings = false,
    border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'},
    post_open_hook = function(_, window)
      vim.api.nvim_win_set_option(window, 'spell', false)
      vim.api.nvim_win_set_option(window, 'signcolumn', 'no')
    end,
  })
end

return M
