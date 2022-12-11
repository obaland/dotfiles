-- plugin: lualine.nvim
-- see: https://github.com/simrat39/symbols-outline.nvim

local M = {}

function M.setup()
  require('symbols-outline').setup({
    highlight_hovered_item = true,
    show_guides = true,
    show_number = true,
    auto_preview = false,
    position = 'right',
    width = 30,
    keymaps = {
      clase = {'<Esc>', 'q'},
      goto_location = '<CR>',
      focus_location = 'o',
      hover_symbol = 'K',
      toggle_preview = 'p',
      rename_symbol = 'r',
      code_actions = 'a',
    },
  })

  vim.cmd([[
    augroup user-symbols-outline
      autocmd!
      autocmd FileType Outline setlocal cursorline
      autocmd WinEnter,BufEnter Outline setlocal cursorline
      autocmd WinLeave,BufLeave Outline setlocal nocursorline
    augroup END
  ]])
end

return M
