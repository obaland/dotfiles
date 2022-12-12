-- plugin: which-key
-- see: https://github.com/folke/which-key.nvim

local ok, whichkey = pcall(require, 'which-key')
if not ok then
  return
end

whichkey.setup({
  icons = {
    breadcrumb = '»',
    separator = '  ',
    group = '+',
  },

  popup_mappings = {
    scroll_down = '<C-d>',
    scroll_up   = '<C-u>',
  },

  window = {
    border = 'single',
  },

  layout = {
    spacing = 6,
  },

  hidden = {
    '<silent>',
    '<cmd>',
    '<Cmd>',
    '<CR>',
    'call',
    'lua',
    '^:',
    '^ ',
  },
})
