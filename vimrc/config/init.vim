" Initialize
"=============================================================================

" Set custom augroup
augroup user_events
  autocmd!
augroup END

" Enables 24-bit RGB color in the terminal
if has('termguicolors')
  if empty($COLORTERM) || $COLORTERM =~# 'truecolor\|24bit'
    set termguicolors
  endif
endif

if !has('nvim')
  set t_Co=256
  " Set Vim-specific sequences for RGB colors
  " Fixes 'termguicolors' usage in vim+tmux
  " :h xterm-true-color
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

  " Lua script root path
  execute 'set runtimepath+=' . $VIM_PATH
endif

" Disable vim distribution plugins
let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1

let g:loaded_gzip = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1

let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:loaded_2html_plugin = 1
let g:loaded_logiPat = 1
let g:loaded_rrhelper = 1
let g:no_gitrebase_maps = 1
let g:no_man_maps = 1  " See share/nvim/runtime/ftplugin/man.vim

let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1

let g:loaded_remote_plugins = 1
let g:loaded_shada_plugins = 1
let g:loaded_spellfile_plugins = 1
let g:loaded_tutor_mode_plugins = 1

" Intentionally skip loading
let g:did_install_default_menus = 1
let g:did_install_syntax_menu = 1
let g:did_indent_on = 1
"let g:did_load_filetypes = 1
let g:skip_loading_mswin = 1

" Set vimfiles directory

" Setting of terminal encoding.
if !has('gui_running') && core#is_windows()
  " For system.
  set termencoding=cp932
endif

if has('multi_byte_ime')
  set iminsert=0 imsearch=0
endif

" Use English interface.
language message C

" Mapping to leader
let mapleader = "\<Space>"

" Envronment value
let $MYVIMRC = expand('$HOME/.vimrc')

" Disable packpath
if v:version >= 800
  set packpath=
endif

"---------------------------------------------------------------------------
" Data directories
"---------------------------------------------------------------------------
function! s:ensure_data_directories()
  for l:path in [
        \ $CONFIG_PATH,
        \ $VIM_BACKUP,
        \ $VIM_SESSIONS,
        \ $VIM_SWAP,
        \ $VIM_UNDO,
				\ ]
    if !isdirectory(l:path)
      call mkdir(l:path, 'p', 0770)
    endif
  endfor
endfunction

"---------------------------------------------------------------------------
" Plugin
"---------------------------------------------------------------------------

if has('vim_starting')
  call s:ensure_data_directories()
endif

""call s:install_package_manager($CONFIG_PATH)
call vimplug#install($CONFIG_PATH)

" Global variables
" ----------------
if core#is_windows()
  let g:python_host_prog = $VIM_PYTHON_PROG_ROOT . '\python.exe'
  let g:python3_host_prog = $VIM_PYTHON3_PROG_ROOT . '\python.exe'
endif

" In the markdown language,
" the setting to properly highlight in other languages.
let g:markdown_fenced_language = [
      \ 'vim',
      \ 'help'
      \ ]

" vim:set ft=vim sw=2 sts=2 et:
