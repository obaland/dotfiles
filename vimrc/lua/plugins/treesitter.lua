-- plugin: nvim-treesitter
-- see: https://github.com/nvim-treesitter/nvim-treesitter

local M = {}

-- Setup treesitter
function M.setup()
  require('nvim-treesitter').setup({
    install_dir = vim.fn.stdpath('data') .. '/site',
  })

  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
    end,
  })
end

return M
