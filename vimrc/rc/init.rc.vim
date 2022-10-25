" Initialize
"=============================================================================

"-----------------------------------------------------------------------------
" Global functions
"-----------------------------------------------------------------------------

let s:is_windows = has('win32') || has('win64')

function! IsWindows() abort
  return s:is_windows
endfunction

function! IsMac() abort
  return !s:is_windows && !has('win32unix')
      \ && (has('mac') || has('macunix') || has('gui_macvim')
      \     || (!executable('xdg-open') && system('uname') =~? '^darwin'))
endfunction

function! Warning(message) abort
  echohl WarningMsg
  echom 'WARNING: ' . a:message
  echohl None
endfunction

function! Error(message) abort
  echohl ErrorMsg
  echom 'ERROR: ' . a:message
  echohl None
endfunction

function! MakeDirectory(path) abort
  let l:expanded_path = expand(a:path)
  if !isdirectory(l:expanded_path)
    call mkdir(l:expanded_path, 'p')
  endif
endfunction

" Build encodings.
set encoding=utf-8
set fileformat=unix
let &fileencodings = join([
      \ 'utf-8', 'iso-2022-jp', 'sjis', 'cp932',
      \ 'euc-jp', 'utf-16', 'utf-16le'], ',')
let &fileformats = join(['unix', 'dos', 'mac'], ',')

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

" Clear hightlight
nnoremap <ESC><ESC> :nohlsearch<CR>:match<CR>

" Special directories
let $BIN = substitute(expand('<sfile>:p:h:h'), '\\', '/', 'g') . '/bin'

let $CONFIG = expand('~/.config')
call MakeDirectory($CONFIG)

let $TMPFILES = expand('~/vimfiles/tmp')
call MakeDirectory($TMPFILES)

let $UNDOFILES = expand('~/vimfiles/undo')
call MakeDirectory($UNDOFILES)

let $LOGFILES = expand('~/vimfiles/log')
call MakeDirectory($LOGFILES)

let $SESSIONFILES = expand('~/vimfiles/sessions')
call MakeDirectory($SESSIONFILES)

" Envronment value
let $MYVIMRC = expand('$HOME/.vimrc')

" Disable packpath
if v:version >= 800
  set packpath=
endif

"---------------------------------------------------------------------------
" Plugin
"---------------------------------------------------------------------------
let $PLUGINSDIR = expand('$CONFIG/plugins')

function! InstalledPlugin(name) abort
  return isdirectory($PLUGINSDIR . '/' . a:name)
endfunction

"---------------------------------------------------------------------------
" Global variables
"---------------------------------------------------------------------------

" In the markdown language,
" the setting to properly highlight in other languages.
let g:markdown_fenced_language = [
      \ 'vim',
      \ 'help'
      \ ]

"---------------------------------------------------------------------------
" Disable default plugins
"---------------------------------------------------------------------------

" Disable menu.vim
if has('gui_running')
   set guioptions=Mc
endif

let g:loaded_2html_plugin      = 1
let g:loaded_logiPat           = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_gzip              = 1
let g:loaded_man               = 1
let g:loaded_matchit           = 1
let g:loaded_matchparen        = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_rrhelper          = 1
let g:loaded_shada_plugin      = 1
let g:loaded_spellfile_plugin  = 1
let g:loaded_tarPlugin         = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_zipPlugin         = 1

" vim: foldmethod=marker
