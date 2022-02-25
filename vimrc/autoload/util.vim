"-----------------------------------------------------------------------------
" autoload/util.vim
"-----------------------------------------------------------------------------

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
