" Define commands
"=============================================================================

" Functions
"---------------
" Plugin managers
function! s:notify_updates_log()
lua <<EOF
  local dein = require('dein')
  local log = dein.get_updates_log()
  if dein.tap('nvim-notify') then
    require('notify')(log, 'info', {
      title = 'Update plugins',
    })
  else
    vim.fn('core#info')(log)
  end
EOF
endfunction

function! s:dein_update()
  " Remove unused plugins
  call map(dein#check_clean(), 'delete(v:val, "rf")')

  if !core#is_windows() && exists('g:dein#install_github_api_token')
    call dein#check_update(v:true)
  else
    call dein#update()
  endif
endfunction

" Load env
function! s:find_git_root(base_dir)
  let l:current_dir = a:base_dir
  while !empty(l:current_dir)
    if isdirectory(l:current_dir . '/.git')
      return l:current_dir
    endif
    let l:parent_dir = fnamemodify(l:current_dir, ':h')
    if l:parent_dir == l:current_dir
      break
    endif
    let l:current_dir = l:parent_dir
  endwhile
  return ''
endfunction

function! s:load_dot_file(base_dir)
  let l:git_root = s:find_git_root(a:base_dir)
  if !empty(l:git_root)
    let l:env_file = l:git_root . '/.env'
    if filereadable(l:env_file)
      let l:lines = readfile(l:env_file)
      for l:line in l:lines
        if l:line !~ '^\s*#' && l:line =~ '='
          let l:var = substitute(l:line, '^\s*\(.\{-}\)\s*=\s*\(.*\)\s*$', '\1', '')
          let l:val = substitute(l:line, '^\s*\(.\{-}\)\s*=\s*\(.*\)\s*$', '\2', '')
          execute 'let $' . l:var . ' = "' . l:val . '"'
        endif
      endfor
      echo "Loaded .env from " . l:env_file
    else
      echo "No .env file found in " . l:git_root
    endif
  else
    echo "No Git repository found from base directory " . a:base_dir
  endif
endfunction

" Plugin manager
"---------------
command! -nargs=0 DeinUpdate call s:dein_update()
command! -nargs=0 DeinClearState call dein#clear_state()

" Load env
"-----------------------------------------------------------------------------
command! -nargs=? LoadProjectEnv call s:load_dot_file(<q-args> == '' ? getcwd() : <q-args>)

" File controls
"-----------------------------------------------------------------------------
" encodings
command! -nargs=0 EncodeUTF8 set fileencoding=utf-8
command! -nargs=0 EncodeCP932 set fileencoding=cp932
command! -nargs=0 EncodeSJIS set fileencoding=sjis
command! -nargs=0 ReloadEncodeUTF8 edit ++enc=utf-8
command! -nargs=0 ReloadEncodeCP932 edit ++enc=cp932
command! -nargs=0 ReloadEncodeSJIS edit ++enc=sjis

" file formats
command! -nargs=0 FileFormatUnix set fileformat=unix
command! -nargs=0 FileFormatDos set fileformat=dos
command! -nargs=0 ReloadFileFormatUnix edit ++ff=unix
command! -nargs=0 ReloadFileFormatDos edit ++ff=dos

" Utility
"-----------------------------------------------------------------------------
" Remove whitespace at the end of a line.
command! -nargs=0 TrimSpace %s/\s\+$//ge

" Check highlight
"-----------------------------------------------------------------------------
command! -nargs=0 ShowHighlightGroup
      \ echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
command! -nargs=0 ShowHighlightItem
      \ echom synIDattr(synID(line('.'), col('.'), 1), 'name')

" vim:set ft=vim sw=2 sts=2 et:
