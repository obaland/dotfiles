" lightline.rc.vim
"=============================================================================

let s:icons = {
      \ 'separator': {
      \   'left': "\ue0b0",
      \   'right': "\ue0b2",
      \ },
      \ 'subseparator': {
      \   'left': "\ue0b1",
      \   'right': "\ue0b3",
      \ },
      \ 'linenumber': "\ue0a1",
      \ 'columnnumber': "\ue0a3",
      \ 'modified': "\uf8ea",
      \ 'nomodifiable': "\uf8ee",
      \ 'readonly': "\ue0a2",
      \ 'gitbranch': "\ue0a0",
      \ }

let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'mode_map': {'c': 'NORMAL'},
      \ 'active': {
      \   'left': [
      \     ['mode', 'paste'],
      \     ['fugitive', 'readonly', 'vfiler', 'filename', 'modified'],
      \     ['cocstatus'],
      \   ],
      \   'right': [
      \     ['lineinfo'],
      \     ['percent'],
      \     ['fileformat', 'fileencoding', 'filetype'],
      \   ]
      \ },
      \ 'tab': {
      \   'active': ['tabnum', 'filename', 'modified'],
      \   'inactive': ['tabnum', 'filename', 'modified']
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'fileencoding': 'LightLineFileencoding',
      \   'fileformat': 'LightLineFileformat',
      \   'filename': 'LightLineFilename',
      \   'filetype': 'LightLineFiletype',
      \   'fugitive': 'LightLineFugitive',
      \   'mode': 'LightLineMode',
      \   'modified': 'LightLineModified',
      \   'readonly': 'LightLineReadonly',
      \   'vfiler': 'vfiler#status',
      \ },
      \ 'component_expand': {
      \   'lineinfo': 'LightLineLineInfo',
      \   'percent': 'LightLinePercent',
      \   'tabs': 'LightLineTabs',
      \ },
      \ 'tab_component_function': {
      \   'modified': 'LightLineTabModified',
      \   'readonly': 'LightLineTabReadonly',
      \ },
      \ 'separator': {
      \   'left': s:icons.separator.left, 'right': s:icons.separator.right,
      \ },
      \ 'subseparator': {
      \   'left': s:icons.subseparator.left, 'right': s:icons.subseparator.right,
      \ },
      \ 'tabline_separator': {
      \   'left': s:icons.separator.left, 'right': s:icons.separator.right,
      \ },
      \ 'tabline_subseparator': {
      \   'left': s:icons.subseparator.left, 'right': s:icons.subseparator.right,
      \ },
      \ }

function! s:is_visible_width() abort
  return winwidth(0) > 70
endfunction

function! s:is_vfiler() abort
  return &filetype =~ 'vfiler'
endfunction

function! s:is_help() abort
  return &filetype =~ 'help'
endfunction

function! s:is_visible() abort
  return s:is_visible_width() && !s:is_vfiler() && !s:is_help()
endfunction

function! LightLineLineInfo() abort
  if !s:is_visible_width() || s:is_vfiler()
    return ''
  endif
  let l:line = line('$')
  let l:value = l:line
  let l:digit = 1
  while (l:value % 10) > 0
    let l:digit += 1
    let l:value /= 10
  endwhile
  return printf('%s %%%dl/%%L %s %%2c', s:icons.linenumber, l:digit, s:icons.columnnumber)
endfunction

function! LightLinePercent() abort
  return s:is_visible() ? '%3p%%' : ''
endfunction

function! LightLineModified() abort
  return s:is_visible() ? (&modified ? s:icons.modified : &modifiable ? '' : s:icons.nomodifiable) : ''
endfunction

function! LightLineReadonly() abort
  return &readonly ? s:icons.readonly : ''
endfunction

function! LightLineFilename() abort
  if s:is_vfiler()
    return ''
  endif
  let l:filename = expand('%:t')
  return WebDevIconsGetFileTypeSymbol() . ' ' . (empty(l:filename) ? '[No Name]' : l:filename)
endfunction

function! LightLineFugitive() abort
  if !s:is_visible()
    return ''
  endif
  " autoload may not be loaded, use try~catch.
  try
    let head = FugitiveHead()
    return head == '' ? '' : s:icons.gitbranch . ' ' . head
  catch /E117.*/
    return ''
  endtry
endfunction

function! LightLineFileformat() abort
  return s:is_visible() ? WebDevIconsGetFileFormatSymbol() . ' ' . &fileformat : ''
endfunction

function! LightLineFiletype() abort
  return s:is_visible() ? (strlen(&filetype) ? WebDevIconsGetFileTypeSymbol() . ' ' . &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding() abort
  return s:is_visible() ? (strlen(&fileencoding) ? &fileencoding : &encoding) : ''
endfunction

function! LightLineMode() abort
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightLineTabs() abort
  let [x, y, z] = [[], [], []]
  let nr = tabpagenr()
  let cnt = tabpagenr('$')
  for i in range(1, cnt)
    call add(i < nr ? x : i == nr ? y : z, '%'. i . 'T%{lightline#onetab(' . i . ',' . (i == nr) . ')}' . (i == cnt ? '%T' : ''))
  endfor

  let abbr = '...'
  let n = min([max([winwidth(0) / 40, 2]), 8])
  if len(x) > n && len(z) > n
    let x = extend(add(x[:n/2-1], abbr), x[-(n+1)/2:])
    let z = extend(add(z[:(n+1)/2-1], abbr), z[-n/2:])
  elseif len(x) + len(z) > 2 * n
    if len(x) > n
      let x = extend(add(x[:(2*n-len(z))/2-1], abbr), x[-(2*n-len(z)+1)/2:])
    elseif len(z) > n
      let z = extend(add(z[:(2*n-len(x)+1)/2-1], abbr), z[-(2*n-len(x))/2:])
    endif
  endif
  return [x, y, z]
endfunction

function! LightLineTabModified(n) abort
  let winnr = tabpagewinnr(a:n)
  return gettabwinvar(a:n, winnr, '&modified') ? s:icons.modified : gettabwinvar(a:n, winnr, '&modifiable') ? '' : s:icons.nomodifiable
endfunction

function! LightLineTabReadonly(n) abort
  let winnr = tabpagewinnr(a:n)
  return gettabwinvar(a:n, winnr, '&readonly') ? s:icons.readonly : ''
endfunction
