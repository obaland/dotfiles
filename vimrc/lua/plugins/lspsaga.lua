-- lspsaga
-- see: https://github.com/glepnir/lspsaga.nvim

local M = {}

function M.setup()
  require('lspsaga').setup({
    max_preview_lines = 10,
    border_style = 'rounded',
    finder_action_keys = {
      open = 'o',
      vsplit = 'v',
      split = 's',
      quit = {'q', '<Esc>'},
      scroll_down = '<C-f>',
      scroll_up = '<C-b>',
    },
    code_action_keys = {
      quit = {'q', '<Esc>'},
      exec = '<CR>',
    },
    rename_action_quit = {'<C-c>', '<Esc>'},
  })
end

return M
