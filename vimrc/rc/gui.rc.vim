" For GUI:
"=============================================================================

"-----------------------------------------------------------------------------
" Fonts:
"-----------------------------------------------------------------------------
if IsWindows()
  set encoding=utf8
  set guifont=Source_Code_Pro:h10
  set guifontwide=MS_Gothic:h10
  set ambiwidth=double

  " Number of pixel lines inserted between characters.
  set linespace=1

  " Automatically measure and determine the width of some USC characters.
  if has('kaoriya')
    set ambiwidth=auto
  endif
endif

"---------------------------------------------------------------------------
" Mouse:
"---------------------------------------------------------------------------

" Enables mouse support. (a: Normal/Visual/Insert/Command-line modes, and help
" file)
set mouse=a
" The window that the mouse pointer is on is automatically activated.
" (nomousefocus: off)
set nomousefocus
" When on, the mouse pointer is hidden when characters are typed. (nomousehide:
" off)
set mousehide

"-----------------------------------------------------------------------------
" Options:
"-----------------------------------------------------------------------------

" Settings for Japanese input.
if has('multi_byte_ime') || has('xim')
  " Set cursor color when IME is ON. (Purple)
  highlight CursorIM guibg=Purple guifg=NONE
  " Default IME state setting in insert and search mode.
  set iminsert=0 imsearch=0
endif

" vim: foldmethod=marker
