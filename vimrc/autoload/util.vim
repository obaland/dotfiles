"-----------------------------------------------------------------------------
" autoload/util.vim
"-----------------------------------------------------------------------------

let s:is_windows = has('win32') || has('win64')

function! util#is_windows() abort
  return s:is_windows
endfunction

function! util#is_mac() abort
  return !s:is_windows && !has('win32unix')
      \ && (has('mac') || has('macunix') || has('gui_macvim')
      \     || (!executable('xdg-open') && system('uname') =~? '^darwin'))
endfunction

function! util#warning(message) abort
  echohl WarningMsg
  echom 'WARNING: ' . a:message
  echohl None
endfunction

function! util#error(message) abort
  echohl ErrorMsg
  echom 'ERROR: ' . a:message
  echohl None
endfunction

function! util#make_directory(path) abort
  let l:expanded_path = expand(a:path)
  if !isdirectory(l:expanded_path)
    call mkdir(l:expanded_path, 'p')
  endif
endfunction

function! util#unique(list)
  let l:visited = {}
  let l:unique = []
  for l in a:list
    if !empty(l) && !has_key(l:visited, l)
      call add(l:unique, l)
      let l:visited[l] = 1
    endif
  endfor
  return l:unique
endfunction

function! util#normalize_path(path)
  return substitute(expand(a:path, ':p'), '\\', '/', 'g')
endfunction
