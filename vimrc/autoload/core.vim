" core.vim
"=============================================================================
"
" Vim directories
let $CONFIG_PATH = expand('~/.config')
let $VIM_PATH = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
let $VIM_RC_PATH = $VIM_PATH . '/rc'
let $VIM_CONFIGS_PATH = $VIM_PATH . '/configs'
let $VIM_FILES = expand('~/vimfiles')
let $VIM_BACKUP = $VIM_FILES . '/backup'
let $VIM_SESSIONS = $VIM_FILES . '/sessions'
let $VIM_SWAP = $VIM_FILES . '/swap'
let $VIM_UNDO = $VIM_FILES . '/swap'

let s:is_windows = has('win32') || has('win64')
let s:is_mac = !s:is_windows && !has('win32unix')
      \ && (has('mac') || has('macunix') || has('gui_macvim')
      \     || (!executable('xdg-open') && system('uname') =~? '^darwin'))

" Convert string to list
function! s:str2list(expr) abort
  return type(a:expr) ==# v:t_list ? a:expr : split(a:expr, '\n')
endfunction

function! core#is_windows() abort
  return s:is_windows
endfunction

function! core#is_mac() abort
  return s:is_mac
endfunction

function! core#mkdir(path) abort
  let l:expanded_path = expand(a:path)
  if !isdirectory(l:expanded_path)
    call mkdir(l:expanded_path, 'p')
  endif
endfunction

function! core#source(path) abort
  let l:abspath = resolve($VIM_RC_PATH . '/'. a:path)
  execute 'source' fnameescape(l:abspath)
endfunction

function! core#info(message, ...) abort
  let l:prefix = get(a:000, 0, '[vimrc]')
  for l:message in s:str2list(a:message)
    echom l:prefix . ' ' . l:message
  endfor
endfunction

function! core#warning(message, ...) abort
  let l:prefix = get(a:000, 0, '[vimrc]')
  for l:message in s:str2list(a:message)
    echohl WarningMsg | echomsg l:prefix . ' ' . l:message | echohl None
  endfor
endfunction

function! core#error(message, ...) abort
  let l:prefix = get(a:000, 0, '[vimrc]')
  for l:message in s:str2list(a:message)
    echohl ErrorMsg | echomsg l:prefix . ' ' . l:message | echohl None
  endfor
endfunction

" vim:set ft=vim sw=2 sts=2 et:
