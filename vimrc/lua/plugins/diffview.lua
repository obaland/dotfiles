-- plugin: diffview.nvim
-- see: https://github.com/sindrets/diffview.nvim

local M = {}

function M.setup()
  vim.api.nvim_exec([[
  augroup user_plugins_diffview
    autocmd!
    autocmd WinEnter,BufEnter diffview://* setlocal cursorline
    autocmd WinEnter,BufEnter diffview:///panels/* setlocal winhighlight=CursorLine:WildMenu
  augroup END
  ]], false)

  local cb = require('diffview/config').diffview_callback

  require('diffview').setup({
    enhanced_diff_hl = true,
    key_bindings = {
      view = {
        ['q']       = '<cmd>DiffviewClose<CR>',
        ['<TAB>']   = cb('select_next_entry'),
        ['<S-TAB>'] = cb('select_prev_entry'),
        [';a']      = cb('focus_files'),
        [';e']      = cb('toggle_files'),
      },
      file_panel = {
        ['q']       = '<cmd>DiffviewClose<CR>',
        ['j']       = cb('next_entry'),
        ['<DOWN>']  = cb('next_entry'),
        ['k']       = cb('prev_entry'),
        ['<UP>']    = cb('prev_entry'),
        ['h']       = cb('prev_entry'),
        ['l']       = cb('select_entry'),
        ['<CR>']    = cb('select_entry'),
        ['o']       = cb('focus_entry'),
        ['gf']      = cb('goto_file'),
        ['gs']      = cb('goto_file_split'),
        ['gt']      = cb('goto_file_tab'),
        ['r']       = cb('refresh_files'),
        ['R']       = cb('refresh_files'),
        ['<C-R>']   = cb('refresh_files'),
        ['<TAB>']   = cb('select_next_entry'),
        ['<S_TAB>'] = cb('select_prev_entry'),
        [';a']      = cb('focus_files'),
        [';e']      = cb('toggle_files'),
      },
      file_history_panel = {
        ['o']    = cb('focus_entry'),
        ['l']    = cb('select_entry'),
        ['<CR>'] = cb('select_entry'),
        ['O']    = cb('options'),
      },
      option_panel = {
        ['<TAB>'] = cb('select'),
        ['q>']    = cb('close'),
      },
    }
  })
end

return M
