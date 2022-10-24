" plugins.vim
"=============================================================================

let s:plugin_dir = expand('$CONFIG/plugins')

function! s:installed(name) abort
  return isdirectory(s:plugin_dir . '/' . a:name)
endfunction

"-----------------------------------------------------------------------------
" Install functions for each plugins
"-----------------------------------------------------------------------------

function s:updated(info)
  let l:status = a:info.status
  return l:status == 'installed' || l:status == 'updated' || a:info.force
endfunction

function InstallMarkdownPreview(info)
  if !s:updated(a:info)
    return
  endif
  let l:cmd = 'cd app && '
  let l:cmd .= IsWindows() ? 'install.cmd' : 'bash install.sh' 
  execute '!' . l:cmd
endfunction

"-----------------------------------------------------------------------------
" Plugin section
"-----------------------------------------------------------------------------

call plug#begin(s:plugin_dir)

Plug 'airblade/vim-gitgutter'
Plug 'guns/xterm-color-table.vim'
Plug 'iamcco/markdown-preview.nvim',
      \ {
        \ 'for': ['plantuml', 'markdown'],
        \ 'do': function('InstallMarkdownPreview')
      \ }
Plug 'icymind/NeoSolarized'
Plug 'itchyny/lightline.vim'
Plug 'kana/vim-operator-user'
Plug 'liuchengxu/vista.vim'
Plug 'obaland/vfiler.vim'
Plug 'obaland/vfiler-column-devicons'
Plug 'obaland/vfiler-fzf'
Plug 'tpope/vim-fugitive'
Plug 'tyru/open-browser.vim'
Plug 'vim-jp/vimdoc-ja'
Plug 'rhysd/vim-operator-surround'
Plug 'ryanoasis/vim-devicons'

if has('nvim')
  " for Neovim
  Plug 'obaland/panvimdoc'
  Plug 'obaland/plenary.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-telescope/telescope.nvim', {'branch': '0.1.x' }
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'onsails/lspkind-nvim'
  Plug 'rafamadriz/friendly-snippets'
  Plug 'tami5/lspsaga.nvim'
  Plug 'williamboman/nvim-lsp-installer'

  if IsWindows()
    Plug 'tzachar/cmp-tabnine', {'do': 'powershell ./install.ps1'}
  else
    Plug 'tzachar/cmp-tabnine', {'do': './install.sh'}
  end
else
  " for Vim
  Plug 'antoinemadec/coc-fzf', {'branch': 'release'}
  Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
  Plug 'junegunn/fzf.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

call plug#end()

"-----------------------------------------------------------------------------
" Settings for each plugins
"-----------------------------------------------------------------------------

function s:source(name) abort
  let l:path = resolve(expand('~/.vim/rc/plugins/' . a:name))
  execute 'source' fnameescape(l:path)
endfunction

function s:load_settings(settings) abort
  for setting in a:settings
    if s:installed(setting.name)
      call s:source(setting.rc)
    endif
  endfor
endfunction

" for markdown-preview.nvim
if s:installed('markdown-preview.nvim')
  let g:mkdp_command_for_global = 1
  "let g:mkdp_browserfunc = 'OpenBrowser'
endif

" for open-browser
if s:installed('open-browser.vim')
  if IsWindows()
    " Note: need to set the directory path of 'chrome.exe' in PATH environment variable.
    let g:openbrowser_browser_commands = [
          \ {'name': 'chrome.exe',  'args': ['{browser}', '{uri}']}
          \ ]
  endif
endif

" for vim-operator-surround
if s:installed('vim-operator-surround')
  map <silent>sa <Plug>(operator-surround-append)
  map <silent>sd <Plug>(operator-surround-delete)
  map <silent>sr <Plug>(operator-surround-replace)
endif

" for vim-operator-user
if s:installed('vim-operator-user')
  let g:plantuml_executable_script = 'java -jar ' . 
        \ fnamemodify('~/.vim/tools/plantuml.jar', ':p')
endif

" for vista.vim
if s:installed('vista.vim')
  if has('nvim')
    nnoremap <silent><nowait> <Leader>v :<C-u>Vista nvim_lsp<CR>
  else
    nnoremap <silent><nowait> <Leader>v :<C-u>Vista coc<CR>
  endif
endif

let s:settings = [
      \ {'name': 'lightline.vim', 'rc': 'lightline.rc.vim'},
      \ {'name': 'vfiler.vim', 'rc': 'vfiler.rc.vim'},
      \ ]

let s:nvim_settings = [
      \ {'name': 'nvim-treesitter', 'rc': 'nvim-treesitter.rc.vim'},
      \ {'name': 'nvim-cmp', 'rc': 'nvim-cmp.rc.vim'},
      \ {'name': 'nvim-lspconfig', 'rc': 'nvim-lspconfig.rc.vim'},
      \ {'name': 'telescope.nvim', 'rc': 'telescope.rc.vim'},
      \ {'name': 'lspsage.nvim', 'rc': 'lspsage.rc.vim'},
      \ ]

let s:vim_settings = [
      \ {'name': 'coc.nvim', 'rc': 'coc.rc.vim'},
      \ {'name': 'fzf.vim', 'rc': 'fzf.rc.vim'},
      \ ]

call s:load_settings(s:settings)

if has('nvim')
  call s:load_settings(s:nvim_settings)
else
  call s:load_settings(s:vim_settings)
endif

" vim: foldmethod=marker
