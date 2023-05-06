" plugins.vim
"=============================================================================

call vimplug#begin()

Plug 'obaland/vfiler.vim'
Plug 'obaland/vfiler-column-devicons'

Plug 'vim-jp/vimdoc-ja', { 'for': 'help' }

call vimplug#end()

" Setup plugins
"--------------

if has('nvim')
  call v:lua.require('plugins').setup()
endif

" vim:set ft=vim sw=2 sts=2 et:
