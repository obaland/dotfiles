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

let s:preview_path = $BIN . '/fzf/'
if IsWindows()
  let s:preview_path .= 'preview.bat'
  let s:preview = 'cmd /c ' . s:preview_path
else
  let s:preview_path .= 'preview.sh'
  let s:preview = 'bash ' . s:preview_path
end

let s:default_options = {
      \ 'layout': 'reverse',
      \ 'cycle': v:true,
      \ 'preview': s:preview,
      \ 'preview-window': 'right,border-left',
      \ }

function! s:merge_options(options, ...) abort
  let l:optdict = deepcopy(s:default_options)
  for l:key in keys(a:options)
    let l:optdict[l:key]  = a:options[l:key]
  endfor

  if has_key(l:optdict, 'no-preview')
    " disable preivew
    call remove(l:optdict, 'preview')
    call remove(l:optdict, 'no-preview')
  endif

  let l:placeholder = get(a:000, 0, '{}')
  let l:options = []
  for l:key in keys(l:optdict)
    let l:v = l:optdict[l:key]
    if l:key == 'preview' && !empty(l:v)
      let l:v .= ' ' . l:placeholder
    endif

    if type(l:v) == v:t_bool
      if l:v == v:true
        call add(l:options, '--' . l:key)
      endif
    else
      call add(l:options, '--' . l:key)
      call add(l:options, l:v)
    endif
  endfor
  return l:options
endfunction

function! s:wrap(...) abort
  let l:spec = get(a:000, 0, {})
  let l:optdict = deepcopy(s:default_options)
  if has_key(l:spec, 'options')
    for l:key in keys(l:spec.options)
      let l:optdict[l:key]  = l:spec.options[l:key]
    endfor
  endif

  if has_key(l:optdict, 'no-preview') && l:optdict['no-preview']
    " disable preivew
    call remove(l:optdict, 'preview')
    call remove(l:optdict, 'no-preview')
  endif

  let l:placeholder = get(l:spec, 'placeholder', '{}')
  let l:options = []
  for l:key in keys(l:optdict)
    let l:v = l:optdict[l:key]
    if l:key == 'preview' && !empty(l:v)
      let l:v .= ' ' . l:placeholder
    endif

    if type(l:v) == v:t_bool
      if l:v == v:true
        call add(l:options, '--' . l:key)
      endif
    else
      call add(l:options, '--' . l:key)
      call add(l:options, l:v)
    endif
  endfor
  return {
        \'options': l:options
        \ }
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
" Files
"---------------------------------------------------------------------------

function! s:buffers() abort
  return fzf#vim#buffers('', {'options': s:merge_options({}, '{1}')})
endfunction

"---------------------------------------------------------------------------
" Files
"---------------------------------------------------------------------------

function! s:files(dir) abort
  return fzf#vim#files(a:dir, {'options': s:merge_options({})})
endfunction

function! s:gitfiles() abort
  return fzf#vim#gitfiles('', {'options': s:merge_options({})})
endfunction

function! s:smart_files() abort
  let l:gitroot = s:get_git_root()
  if len(l:gitroot)
    return s:gitfiles()
  endif
  return s:files('')
endfunction

function! s:history() abort
  return fzf#vim#history({'options': s:merge_options({})})
endfunction

"---------------------------------------------------------------------------
" Grep
"---------------------------------------------------------------------------

function! s:grep_command(command, options) abort
  return a:command . ' ' . join(a:options, ' ')
endfunction

function! s:gitgrep(pattern) abort
  let l:dir = s:get_git_root()
  let l:cmdopts = [
        \ '--column',
        \ '--color=auto',
        \ '--ignore-case',
        \ '--line-number',
        \ '--no-heading',
        \ '--recursive',
        \ '--untracked',
        \ ]
  let l:cmdformat = s:grep_command('git grep', l:cmdopts) . ' -- %s'
  let l:options = {
        \ 'bind': 'change:reload:' . printf(l:cmdformat, '{q}'),
        \ }
  if !empty(a:pattern)
    let l:options['query'] = a:pattern
  endif
  let l:spec = {
        \ 'dir': l:dir,
        \ 'options': s:merge_options(l:options),
        \ }
  return fzf#vim#grep(
        \ printf(l:cmdformat, shellescape(a:pattern)),
        \ v:true, l:spec
        \ )
endfunction

function! s:ripgrep(pattern, ...) abort
  let l:pattern = shellescape(a:pattern)
  let l:dir = get(a:000, 0, getcwd())
  let l:cmdopts = [
        \ '--column',
        \ '--color=always',
        \ '--smart-case',
        \ '--line-number',
        \ '--no-heading',
        \ '--fixed-strings',
        \ ]
  let l:cmdformat = s:grep_command('rg', l:cmdopts) . ' -- %s || true'
  let l:options = {
        \ 'bind': 'change:reload:' . printf(l:cmdformat, '{q}'),
        \ }
  if !empty(a:pattern)
    let l:options['query'] = a:pattern
  endif
  let l:spec = {
        \ 'dir': l:dir,
        \ 'options': s:merge_options(l:options),
        \ }
  return fzf#vim#grep(
        \ printf(l:cmdformat, l:pattern),
        \ v:true, l:spec
        \ )
endfunction

function! s:grep(pattern, ...) abort
  let l:gitroot = s:get_git_root()
  let l:dir = get(a:000, 0, l:gitroot)
  if empty(l:dir)
    let l:dir = getcwd()
  endif
  if executable('rg')
    return s:ripgrep(a:pattern, l:dir)
  elseif !empty(l:gitroot)
    return s:gitgrep(a:pattern)
  end
  call Warning('Unable to run grep.')
endfunction

"---------------------------------------------------------------------------
" Mappings
"---------------------------------------------------------------------------

function! s:mappings(mode) abort
  let l:options = {
        \ 'no-preview': v:true,
        \ }
  return fzf#vim#maps(a:mode, {'options': l:options})
endfunction

"---------------------------------------------------------------------------
" Registers
"---------------------------------------------------------------------------

function! s:paste(reg) abort
  execute ':normal ' . split(a:reg, ' ')[2] . 'p'
endfunction

function! s:registers() abort
  let l:regs = split(execute(':registers'), "\n")

  " header
  let l:header = l:regs[0]
  call remove(l:regs, 0)
  let l:options = {
        \ 'ansi': v:true,
        \ 'no-multi': v:true,
        \ 'no-preview': v:true,
        \ 'prompt': 'Reg> ',
        \ 'header': l:header,
        \ }
  let l:spec = {
        \ 'source': l:regs,
        \ 'sink': function('s:paste'),
        \ 'options': s:merge_options(l:options),
        \ }
  call fzf#run(fzf#wrap('registers', l:spec, 0))
endfunction

"---------------------------------------------------------------------------
" autocmd list
"---------------------------------------------------------------------------

" TODO:
function! s:autocmds() abort
  let l:autocmds = split(execute(':autocmd'), "\n")
  let l:options = {
        \ 'ansi': v:true,
        \ 'no-multi': v:true,
        \ 'no-preview': v:true,
        \ 'prompt': 'Autocmds> ',
        \ }
  let l:spec = {
        \ 'source': l:autocmds,
        \ 'sink': '',
        \ 'options': s:merge_options(l:options),
        \ }
  call fzf#run(fzf#wrap('autocmds', l:spec, 0))
endfunction

"---------------------------------------------------------------------------
" Key mappings
"---------------------------------------------------------------------------

" Autocmds
nnoremap <silent><nowait> <Leader>a :call <SID>autocmds()<CR>

" Buffers
nnoremap <silent><nowait> <Leader>b :call <SID>buffers()<CR>

" Files
nnoremap <silent><nowait> <Leader>ff :call <SID>smart_files()<CR>
nnoremap <silent><nowait> <Leader>fb :call <SID>files(expand('%:p:h'))<CR>
nnoremap <silent><nowait> <Leader>fm :call <SID>history()<CR>

" Grep
nnoremap <silent><nowait> <Leader>gg :call <SID>grep('')<CR>
nnoremap <silent><nowait> <Leader>gw :call <SID>grep(expand('<cword>'))<CR>
nnoremap <silent><nowait> <Leader>gb :call <SID>grep(expand('', expand('%:p:h')))<CR>

" Registers
nnoremap <silent><nowait> <Leader>r :call <SID>registers()<CR>

" Mapping selecting mappings
nmap <Leader><tab> :call <SID>mappings('n')<CR>
xmap <Leader><tab> :call <SID>mappings('x')<CR>
omap <Leader><tab> :call <SID>mappings('o')<CR>
imap <Leader><tab> :call <SID>mappings('i')<CR>

" Coc sources
"let g:coc_fzf_opts = copy(s:default_opts)
"
"nnoremap <silent><nowait> <Leader><space> :<C-u>CocFzfList<CR>
"nnoremap <silent><nowait> <Leader>dd      :<C-u>CocFzfList diagnostics<CR>
"nnoremap <silent><nowait> <Leader>db      :<C-u>CocFzfList diagnostics --current-buf<CR>
"nnoremap <silent><nowait> <Leader>c       :<C-u>CocFzfList commands<CR>
"nnoremap <silent><nowait> <Leader>e       :<C-u>CocFzfList extensions<CR>
"nnoremap <silent><nowait> <Leader>l       :<C-u>CocFzfList location<CR>
"nnoremap <silent><nowait> <Leader>o       :<C-u>CocFzfList outline<CR>
"nnoremap <silent><nowait> <Leader>s       :<C-u>CocFzfList symbols<CR>
"nnoremap <silent><nowait> <Leader>p       :<C-u>CocFzfListResume<CR>
