" Define commands
"=============================================================================

" Plugin manager
"---------------
command! -nargs=0 DeinUpdate call s:dein_update()
command! -nargs=0 DeinClearState call dein#clear_state()

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
