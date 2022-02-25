"-----------------------------------------------------------------------------
" fzf.rc.vim
"-----------------------------------------------------------------------------

" Enable per-command history
" - History files will be stored in the specified directory
" - When set, CTRL-N and CTRL-P will be bound to 'next-history' and
"   'previous-history' instead of 'down' and 'up'.
let g:fzf_history_dir = '~/vimfiles/fzf/history'

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit',
      \ }

"let g:fzf_layout = {'window':
"      \ {'width': 0.9, 'height': 0.6, 'relative': v:false}
"      \ }
let g:fzf_layout = {'down': '~40%'}

"---------------------------------------------------------------------------
" Options
"---------------------------------------------------------------------------

let s:default_opts = ['--layout=reverse', '--cycle']

function! s:to_options(dict)
  let l:opts = []
  for l:key in keys(a:dict)
    let l:v = a:dict[l:key]
    if type(l:v) == v:t_bool
      if l:v == v:true
        call add(l:opts, '--' . l:key)
      endif
    else
      call add(l:opts, '--' . l:key . '=' . l:v)
    endif
  endfor
  return { 'options': l:opts }
endfunction

"---------------------------------------------------------------------------
" Libraries
"---------------------------------------------------------------------------

function! s:get_git_root() abort
  let l:root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  return v:shell_error ? '' : l:root
endfunction

"---------------------------------------------------------------------------
" autocmd
"---------------------------------------------------------------------------

augroup MyFzfCmd
  autocmd!
  if has('nvim')
    autocmd TermOpen * tnoremap <Esc> <C-\><C-n>
    autocmd FileType fzf tunmap <Esc>
  endif
augroup END

"---------------------------------------------------------------------------
" Command Grep
"

function! s:grep(pattern, dir) abort
  if len(s:get_git_root())
    let l:has_column = 1
    let l:name = 'git grep'
    let l:options = [
          \ '--ignore-case',
          \ '--line-number',
          \ '--column',
          \ ]
  elseif executable('grep')
    let l:has_column = 0
    let l:name = 'grep'
    let l:options = [
          \ '--recursive',
          \ '--ignore-case',
          \ '--line-number',
          \ '--exclude-dir=.git',
          \ '--exclude-dir=.npm',
          \ '--exclude-dir=.vs',
          \ '--exclude-dir=__pycache__',
          \ ]
  else
    call util#warning('Not found "grep" comand.')
    return
  endif
  let l:command = printf(
        \ '%s %s -- %s',
        \ l:name, join(l:options, ' '), shellescape(a:pattern)
        \ )
  let l:preview = fzf#vim#with_preview({
        \ 'dir': a:dir,
        \ 'options': s:default_opts
        \ })
  call fzf#vim#grep(l:command, l:has_column, l:preview)
endfunction

function! s:rg(pattern, dir) abort
  let l:options = [
        \ '--column',
        \ '--line-number',
        \ '--no-heading',
        \ '--color=always',
        \ '--smart-case'
        \ ]
  let l:command_format = 'rg ' . join(l:options) . ' -- %s || true'
  let l:initial_command = printf(
        \ l:command_format, shellescape(a:pattern)
        \ )
  let l:reload_command = printf(
        \ l:command_format, '{q}'
        \ )
  let l:spec = [
        \ '--phony',
        \ '--query', a:pattern,
        \ '--bind', 
        \ 'change:reload:' . l:reload_command
        \ ]
  let l:preview = fzf#vim#with_preview({
        \ 'dir': a:dir,
        \ 'options': s:default_opts + l:spec
        \ })
  call fzf#vim#grep(l:initial_command, 1, l:preview)
endfunction

function! s:ag(pattern, dir) abort
  let l:preview = fzf#vim#with_preview({
        \ 'dir': a:dir,
        \ 'options': s:default_opts
        \ })
  let l:options = [
        \ '--ignore-dir={.git}'
        \ ]
  call fzf#vim#ag(a:pattern, join(l:options, ' '), l:preview)
endfunction

" Select search command
let s:grep_func = ''
if executable('rg')
  let s:grep_func = function('s:rg')
elseif executable('ag')
  let s:grep_func = function('s:ag')
elseif executable('grep')
  let s:grep_func = function('s:grep')
endif

function! s:command_grep(pattern, ...) abort
  if s:grep_func == ''
    call util#warning('[fzf.rc]: Need to install the search tool. ("rg" or "ag")')
    return
  endif

  if a:pattern == ''
    let l:pattern = input('Pattern?: ')
    redraw
    if l:pattern == ''
      return
    endif
  endif

  let l:dir = get(a:000, 0, s:get_git_root())
  if l:dir == ''
    let l:dir = getcwd()
  endif
  call s:grep_func(l:pattern, l:dir)
endfunction

"---------------------------------------------------------------------------
" Mappings
"

function! s:command_mappings(mode) abort
  call fzf#vim#maps(a:mode, {'options': s:default_opts})
  "call call('fzf#vim#maps', [a:mode] + s:default_opts)
endfunction

"---------------------------------------------------------------------------
" Key mappings
"

" Buffers
nnoremap <silent><nowait> <Leader>b :call fzf#buffers()<CR>

" Files
nnoremap <silent><nowait> <Leader>ff :call fzf#gitfiles()<CR>
nnoremap <silent><nowait> <Leader>fb :call fzf#files(expand('%:p:h'))<CR>
nnoremap <silent><nowait> <Leader>mf :call fzf#history()<CR>

" Grep
"nnoremap <silent><nowait> <Leader>gg
"      \ :call <SID>command_grep('')<CR>
nnoremap <silent><nowait> <Leader>gg :call fzf#grep()<CR>
nnoremap <silent><nowait> <Leader>gw
      \ :call <SID>command_grep(expand('<cword>'))<CR>
nnoremap <silent><nowait> <Leader>gb
      \ :call <SID>command_grep(expand('', expand('%:p:h')))<CR>

" Registers
nnoremap <silent><nowait> <Leader>r :call fzf#registers()<CR>

" Mapping selecting mappings
nmap <Leader><tab> :call <SID>command_mappings('n')<CR>
xmap <Leader><tab> :call <SID>command_mappings('x')<CR>
omap <Leader><tab> :call <SID>command_mappings('o')<CR>
imap <Leader><tab> :call <SID>command_mappings('i')<CR>

" Coc sources
let g:coc_fzf_opts = copy(s:default_opts)

nnoremap <silent><nowait> <Leader><space> :<C-u>CocFzfList<CR>
nnoremap <silent><nowait> <Leader>dd      :<C-u>CocFzfList diagnostics<CR>
nnoremap <silent><nowait> <Leader>db      :<C-u>CocFzfList diagnostics --current-buf<CR>
nnoremap <silent><nowait> <Leader>c       :<C-u>CocFzfList commands<CR>
nnoremap <silent><nowait> <Leader>e       :<C-u>CocFzfList extensions<CR>
nnoremap <silent><nowait> <Leader>l       :<C-u>CocFzfList location<CR>
nnoremap <silent><nowait> <Leader>o       :<C-u>CocFzfList outline<CR>
nnoremap <silent><nowait> <Leader>s       :<C-u>CocFzfList symbols<CR>
nnoremap <silent><nowait> <Leader>p       :<C-u>CocFzfListResume<CR>
