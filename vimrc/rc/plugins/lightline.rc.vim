" lightline.rc.vim
"=============================================================================

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
  \   'tabs': 'LightLineTabs',
  \ },
  \ 'separator': {
  \   'left': "\ue0b4", 'right': "\ue0b6"
  \ },
  \ 'subseparator': {
  \   'left': "\ue0b5", 'right': "\ue0b7"
  \ },
  \ 'tabline_separator': {
  \   'left': "\ue0b0", 'right': "\ue0b2"
  \ },
  \ 'tabline_subseparator': {
  \   'left': "\ue0b1", 'right': "\ue0b3"
  \ },
  \ }

function! LightLineModified()
  return &filetype =~ 'help' || &filetype =~ 'vfiler' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &filetype !~? 'help' && &filetype !~? 'vfiler' && &readonly ? "\ue0a2" : ""
endfunction

function! LightLineFilename()
  if &filetype =~ 'vfiler'
    return ''
  endif
  return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]' .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  " autoload 配置の関数は一度コールしないと exists が常に0を返すので
  " try ~ catch で対応する
  try
    let head = fugitive#head()
    return head == '' ? '' : "\ue0a0 " . head
  catch /E117.*/
    return ''
  endtry
endfunction

function! LightLineFileformat()
  if winwidth(0) <= 70 || &filetype == 'vfiler'
    return ''
  endif
  return &fileformat
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 && &filetype !~? 'vfiler' ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  if winwidth(0) <= 70 || &filetype == 'vfiler'
    return ''
  endif
  return strlen(&fileencoding) ? &fileencoding : &encoding
endfunction

function! LightLineMode()
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
