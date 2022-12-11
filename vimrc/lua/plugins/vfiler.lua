-- plugin: vfiler.vim
-- see: https://github.com/obaland/vfiler.vim

local M = {}

function M.setup()
  -- column settings
  require'vfiler/columns/indent'.setup { 
    icon = '',
  }

  require'vfiler/status'.setup {
    separator = '',
    subseparator = ':',
  }

  require'vfiler/config'.setup {
    options = {
      columns = 'indent,devicons,name,mode,size,time',
      session = 'share',
    }
  }

  if not vim.fn.has('nvim') then
    -- Vim only
    local sink = require 'vfiler/fzf/sink'
    require'vfiler/fzf/config'.setup {
      action = {
        default = sink.open_by_choose,
      },

      options = {
        '--layout=reverse',
        '--cycle',
      },

      layout = {
        down = '~40%',
      },
    }

    local fzf_action = require 'vfiler/fzf/action'
    require'vfiler/config'.setup {
      mappings = {
        ['f'] = fzf_action.files,
        ['<C-g>'] = fzf_action.rg,
      }
    }
  end
end

function M.start_exprolorer()
  local action = require('vfiler/action')

  local configs = {
    options = {
      auto_cd = true,
      auto_resize = true,
      find_file = true,
      keep = true,
      name = 'exp',
      layout = 'left',
      width = 36,
      columns = 'indent,devicons,name,git',
      git = {
        enabled = true,
        untracked = true,
        ignored = true,
      },
    },

    mappings = {
      ['<C-j>'] = action.move_cursor_bottom_sibling,
      ['<C-k>'] = action.move_cursor_top_sibling,
      ['J'] = action.loop_cursor_down_sibling,
      ['K'] = action.loop_cursor_up_sibling,
    },
  }

  local path = vim.fn.bufname(vim.fn.bufnr())
  if vim.fn.isdirectory(path) ~= 1 then
    path = vim.fn.getcwd()
  end
  path = vim.fn.fnamemodify(path, ':p:h')

  require('vfiler').start(path, configs)
end

return M
