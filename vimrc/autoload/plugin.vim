"-----------------------------------------------------------------------------
" autoload/plugin.vim
"-----------------------------------------------------------------------------

let s:dirpath = expand('$CONFIG/plugins')

function! plugin#dirpath() abort
  return s:dirpath
endfunction

function! plugin#installed(name) abort
  return isdirectory(s:dirpath . '/' . a:name)
endfunction
