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

" Set vimfiles directory

"-----------------------------------------------------------------------------
" Global functions
"-----------------------------------------------------------------------------

let s:is_windows = has('win32') || has('win64')
let s:is_mac = !s:is_windows && !has('win32unix')
      \ && (has('mac') || has('macunix') || has('gui_macvim')
      \     || (!executable('xdg-open') && system('uname') =~? '^darwin'))

function! IsWindows() abort
  return s:is_windows
endfunction

function! IsMac() abort
  return s:is_mac
endfunction

" Convert string to list
function! s:str2list(expr)
  return type(a:expr) ==# v:t_list ? a:expr : split(a:expr, '\n')
endfunction

function! s:error(message)
  for l:message in s:str2list(a:message)
    echohl ErrorMsg | echomsg '[config/init] ' . l:message | echohl None
  endfor
endfunction

" Setting of terminal encoding.
if !has('gui_running') && IsWindows()
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
        \ $CONFIGPATH,
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
function! s:use_package_manager(data_path)
  let l:cache_path = a:data_path . '/dein'
  if has('vim_starting')
    " Add dein to vim's runtimepath
    if &runtimepath !~# '/dein.vim'
      let l:dein_dir = l:cache_path . '/repos/github.com/Shougo/dein.vim'
      " Clone dein if first-time setup
      if !isdirectory(l:dein_dir)
        execute '!git clone https://github.com/Shougo/dein.vim' l:dein_dir
        if v:shell_error
          call s:error('dein installation has failed! is git installed?')
          finish
        endif
      endif
      execute 'set runtimepath^=' . substitute(
            \ fnamemodify(l:dein_dir, ':p') , '[/\\]$', '', '')
    endif

    let g:dein#auto_recache = v:true
    let g:dein#install_progress_type = 'echo'
    let g:dein#install_message_type = 'echo'
    let g:dein#install_max_process = 10
  endif

  " Initialize package manager (dein.vim)
  if dein#load_state(l:cache_path)
    let l:base_dir = $VIM_CONFIG_PATH . '/'
    let l:plugins = l:base_dir . 'plugins.toml'
    let l:plugins_lazy = l:base_dir . 'plugins-lazy.toml'

    call dein#begin(l:cache_path, expand('<sfile>'))

    call dein#load_toml(l:plugins, {'lazy': 0})
    call dein#load_toml(l:plugins_lazy, {'lazy' : 1})

    call dein#end()
    call dein#save_state()

    " Update or install plugins if a change detected
    if dein#check_install()
      call dein#install()
    endif
  endif

  if has('vim_starting')
    filetype plugin indent on
    if !has('nvim-0.8')
      syntax enable
    endif
  endif

  " Enable notifications after initialization
	let g:dein#enable_notification = v:true
endfunction

if has('vim_starting')
  call s:ensure_data_directories()
endif

call s:use_package_manager($CONFIG_PATH)

" Global variables
" ----------------
if IsWindows()
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
