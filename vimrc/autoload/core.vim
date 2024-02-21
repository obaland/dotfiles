" core.vim
"=============================================================================

let s:is_windows = has('win32') || has('win64')
let s:is_mac = !s:is_windows && !has('win32unix')
      \ && (has('mac') || has('macunix') || has('gui_macvim')
      \     || (!executable('xdg-open') && system('uname') =~? '^darwin'))

" Convert string to list
function! s:str2list(expr)
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

function! core#info(message, ...) abort
  let l:prefix = get(a:000, 0, '[config]')
  for l:message in s:str2list(a:message)
    echom l:prefix . ' ' . l:message
  endfor
endfunction

function! core#warning(message, ...) abort
  let l:prefix = get(a:000, 0, '[config]')
  for l:message in s:str2list(a:message)
    echohl WarningMsg | echomsg l:prefix . ' ' . l:message | echohl None
  endfor
endfunction

function! core#error(message, ...) abort
  let l:prefix = get(a:000, 0, '[config]')
  for l:message in s:str2list(a:message)
    echohl ErrorMsg | echomsg l:prefix . ' ' . l:message | echohl None
  endfor
endfunction
