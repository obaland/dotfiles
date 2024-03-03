-- plugin: diffview.nvim
-- see: https://github.com/sindrets/diffview.nvim

local M = {}

function M.setup()
  local augroup = vim.api.nvim_create_augroup('user_diffview', {})
  vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
    group = augroup,
    pattern = 'diffview://*',
    callback = function(_)
      vim.opt_local.cursorline = true
    end,
  })
  vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
    group = augroup,
    pattern = 'diffview:///panels/*',
    callback = function(_)
      vim.opt_local.winhighlight = 'CursorLine:WildMenu'
    end,
  })

  local actions = require('diffview/actions')
  require('diffview').setup({
    enhanced_diff_hl = true,
    key_bindings = {
      view = {
        { 'n', 'q', '<cmd>DiffviewClose<CR>' },
        { 'n', '<Tab>', actions.select_next_entry },
        { 'n', '<S-Tab>', actions.select_prev_entry },
        { 'n', ';a', actions.focus_files },
        { 'n', ';e', actions.toggle_files },
      },
      file_panel = {
        { 'n', 'q', '<cmd>DiffviewClose<CR>' },
        { 'n', 'j', actions.next_entry },
        { 'n', '<DOWN>', actions.next_entry },
        { 'n', 'k', actions.prev_entry },
        { 'n', '<UP>', actions.prev_entry },
        { 'n', 'h', actions.prev_entry },
        { 'n', 'l', actions.select_entry },
        { 'n', '<CR>', actions.select_entry },
        { 'n', 'o', actions.focus_entry },
        { 'n', 'gf', actions.goto_file },
        { 'n', 'gs', actions.goto_file_split },
        { 'n', 'gt', actions.goto_file_tab },
        { 'n', 'r', actions.refresh_files },
        { 'n', 'R', actions.refresh_files },
        { 'n', '<C-R>', actions.refresh_files },
        { 'n', '<TAB>', actions.select_next_entry },
        { 'n', '<S-TAB>', actions.select_prev_entry },
        { 'n', ';a', actions.focus_files },
        { 'n', ';e', actions.toggle_files },
      },
      file_history_panel = {
        { 'n', 'o', actions.focus_files },
        { 'n', 'l', actions.select_entry },
        { 'n', '<CR>', actions.select_entry },
        { 'n', 'O', actions.options },
      },
      option_panel = {
        { 'n', '<TAB>', actions.select_entry },
        { 'n', 'q', actions.close },
      },
    },
  })
end

return M
