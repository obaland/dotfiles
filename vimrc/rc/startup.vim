" startup.vim
"=============================================================================

" Logo
let s:vim_logo = [
      \ '⠀⠀⢀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⡠⢞⠢⡀⠀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⠀',
      \ '⠀ ⡏  ⠀⠀⠀⠀⠀⠀⠀⠀⣿⢡⠒⡌⢻⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢾⡇',
      \ '⠀ ⠳⢷ ⠀⠀⠀⠀⠀⢰⢲⡶⠟⣂⠱⡈⢜⣷⡶⠂⠀⠀⠀⠀⠀⢀⣴⡾⠃',
      \ '⠀⠀⠀⢸ ⠀⠀⠀⠀⠀⢘⣸⡇⡘⢄⠢⣱⡾⠋⠀ ⠀⠀⠀⡠⣶⡿⠋⠀⠀',
      \ '⠀⠀⠀⢸ ⠀⠀⠀⠀⠀⢨⢸⡇⡘⣤⡿⠋⠀⠀⠀⠀⠀⣀⣾⣷⠋⠀⠀⠀⠀',
      \ '⠀⠀⠀⢸ ⠀⠀⠀⠀⠀⢠⢻⣧⡾⠋⠀⠀⠀⠀⠀⠀⣰⣾⠟⢪⡳⣄⠀⠀⠀',
      \ '⠀⢀⠖⣹ ⠀⠀⠀⠀⠀⢐⠺⠋⠀⠀⠀⠀⠀⠀⢠⣾⠟⡁⠎⢆⡙⠮⡓⣄⠀',
      \ '⠰⣡⡌⣿⠀⠀⠀⠀⠀⠀ ⠀⠀⠀⠀⠀⣠⠤⣼⠟⡁⢆⡡⢋⡔⡉⢆⣙⣦⠗',
      \ '⠀⠘⢿⣾ ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⢴⣇⣀⡿⢐⡡⠒⡌⠒⠤⣑⣶⠟⠁⠀',
      \ '⠀⠀⠀⢹⠀⠀⠀⠀⠀⠀⠀⠀⢀⣔⣿⡛⠛⣻⣶⡓⠒⢷⡼⠛⠒⢿⠗⠒⢢⡄',
      \ '⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⢀⣷⠟⣻⠀⢠⡟⡿⠁⢠⣶⡦⠀⢰⡶⡆⠀⣸⠃',
      \ '⠀⠀⠀⢸⠀⠀⠀⠀⠀⢀⣴⡿⠃⣼⠇⢀⡾⣼⠃⠀⣿⣿⠃⢠⡟⣸⠀⢠⡏⠀',
      \ '⠀⠀⠀⢸  ⠀⢀⣴⠟⢿⣦⣤⣿⣤⣬⡿⣿⣤⣬⠿⡯⣤⠬⢿⢯⢤⡬⠇⠀',
      \ '⠀⠀⠀⠘⠛⠛⠛⠛⠁⠀⠀⠙⢿⣦⡐⣄⣶⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
      \ '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
      \ ]

let s:neovim_logo = [
      \ '⠀⠀⣠⣾⣄⠀⠀⠀⠀⠀⢸⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
      \ '⣠⣾⣿⣿⣿⣧⡀⠀⠀⠀⢸⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⣶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
      \ '⡏⢻⣿⣿⣿⣿⣷⡀⠀⠀⢸⣿⣿⣿⡇⠀⠀⢀⡀⢀⣠⣄⡀⠀⠀⠀⣀⣤⣄⡀⠀⠀⠀⣀⣤⣄⡀⠀⣤⣤⡀⠀⠀⢠⣤⣤⣭⣭⠀⣠⣤⣠⣤⣤⡀⣠⣤⣤⣄⠀',
      \ '⡇⠀⠹⣿⣿⣿⣿⣿⣆⠀⢸⣿⣿⣿⡇⠀⠀⢸⡿⠋⠁⠈⢹⡆⢠⡾⠃⠀⠀⠙⣧⢠⣾⠉⠁⠈⠙⣧⡹⣿⣷⠀⢀⣿⣿⠃⣿⣿⠀⣿⣿⡟⠉⢻⣿⡿⠋⠹⣿⣷',
      \ '⡇⠀⠀⢸⠘⢿⣿⣿⣿⣦⢸⣿⣿⣿⡇⠀⠀⢸⡇⠀⠀⠀⢸⡇⢸⡟⠛⠛⠛⠛⠛⢸⡇⠀⠀⠀⠀⣿⡇⢻⣿⣦⣼⣿⠇⠀⣿⣿⠀⣿⣿⠀⠀⢸⣿⡇⠀⠀⣿⣿',
      \ '⡇⠀⠀⢸⠀⠈⢻⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⢸⡇⠀⠀⠀⢸⡇⠘⣷⡀⠀⠀⠀⣀⠸⣗⡀⠀⠀⢀⣿⠃⠀⢻⣿⣿⡏⠀⠀⣿⣿⠀⣿⣿ ⠀⢸⣿⡇⠀⠀⣿⣿',
      \ '⡇⠀⠀⢸⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⡇⠀⠀⠘⠃⠀⠀⠀⠘⠃⠀⠈⠙⠓⠒⠛⠉⠀⠈⠛⠒⠚⠋⠁⠀⠀⠈⠛⠛⠀⠀⠀⠛⠛⠀⠛⠛ ⠀⠘⠛⠃⠀⠀⠛⠛',
      \ '⠙⢦⡀⢸⠀⠀⠀⠀⠙⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
      \ '⠀⠀⠙⢿⠀⠀⠀⠀⠀⠈⢿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
      \ ]

let s:logo = has('nvim') ? s:neovim_logo : s:vim_logo

" Command list
let s:commands = []

if dein#tap('vfiler.vim')
  call add(s:commands, { 'f': [ ' Filer', 'VFiler' ] })
  call add(s:commands, { 'E': [
        \ ' Exprolorer',
        \ 'lua require("plugins/vfiler").start_exprolorer()'
        \ ] })
endif

if dein#tap('telescope.nvim')
  call add(s:commands, { 'F': [
        \ '󰱽 Find File',
        \ 'lua require("plugins/telescope").find_files()',
        \ ] })
  call add(s:commands, { 'g': [
        \ ' Grep',
        \ 'lua require("plugins/telescope").grep()',
        \ ] })
endif

if dein#tap('mason.nvim')
  call add(s:commands, { 'm': [ ' Package Manager', 'Mason' ] })
endif

call add(s:commands, { 'u': [ '󰚰 Update Plugins', 'DeinUpdate' ] })

if has('nvim')
  call add(s:commands, { 'h': [ ' Check Health', 'checkhealth' ] })
endif

function! s:padding_left() abort
  " 5 = space(2) + key(3)
  let l:longest_line = max(map(
        \ copy(s:commands), 'strwidth(values(v:val)[0][0]) + 5'))
  return (winwidth(0) / 2) - (l:longest_line / 2) - 1
endfunction

function! s:header() abort
  let l:pwd = [ '', ' ' . getcwd() ]
  " Pack padding to center height.
  " 9 = top(1) + header(2) + command header(3) + footer(2) + bottom(1)
  let l:height = len(s:logo) + len(l:pwd) + len(s:commands) + 9
  let l:padding = (winheight(0) / 2) - (l:height / 2) - 1
  let l:header = repeat([''], l:padding)
  return l:header + startify#center(s:logo) + startify#center(l:pwd)
endfunction

" Variables
"-----------------------------------------------------------------------------
let g:startify_padding_left = s:padding_left()
let g:startify_custom_header = s:header()
let g:startify_commands = s:commands

" List
"-----------------------------------------------------------------------------
let g:startify_lists = [
      \ { 'type': 'commands',  'header': startify#center(['󰘳 Commands']) },
      \ ]

" vim:set ft=vim sw=2 sts=2 et:
