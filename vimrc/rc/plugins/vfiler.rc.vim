" vfiler.rc.vim
"=============================================================================

function! s:start_exprolorer() abort

lua <<EOF
local action = require 'vfiler/action'
local fzf_action = require 'vfiler/fzf/action'

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

require'vfiler'.start(path, configs)
EOF

endfunction

"-----------------------------------------------------------------------------
" vfiler setting
"-----------------------------------------------------------------------------

lua<<EOF

---- column settings
require'vfiler/columns/indent'.setup { 
  icon = '',
}

-- vfiler fzf setting
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

require'vfiler/status'.setup {
  separator = '',
  subseparator = ':',
}

local fzf_action = require 'vfiler/fzf/action'
require'vfiler/config'.setup {
  options = {
    columns = 'indent,devicons,name,mode,size,time',
    session = 'share',
  },

  mappings = {
    ['f'] = fzf_action.files,
    ['<C-g>'] = fzf_action.rg,
  },
}

EOF

" Explorer view by vfiler.vim.
noremap <silent><Leader>e :call <SID>start_exprolorer()<CR>

" Floating view by vfiler.vim.
noremap <silent><Leader>E <Cmd>VFiler -layout=floating<CR>
