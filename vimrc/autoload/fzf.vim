"-----------------------------------------------------------------------------
" autoload/fzf.vim
"-----------------------------------------------------------------------------

"---------------------------------------------------------------------------
" Options
"---------------------------------------------------------------------------

let s:preview_path = $BIN . '/fzf/'
if util#is_windows()
  let s:preview_path .= 'preview.bat'
  let s:preview = 'cmd /c ' . s:preview_path
else
  let s:preview_path .= 'preview.sh'
  let s:preview = 'bash ' . s:preview_path
end

" Color scheme
function! s:color_scheme_solarized() abort
  let l:base0 = 244
  let l:base1 = 245
  let l:base2 = 254
  let l:base3 = 230
  let l:base00 = 241
  let l:base01 = 240
  let l:base02 = 235
  let l:base03 = 234
  let l:yellow = 136
  let l:orange = 166
  let l:red = 160
  let l:magenta = 125
  let l:violet = 61
  let l:blue = 33
  let l:cyan = 37
  let l:green = 64

  let l:color_table = {
        \ 'fg': -1,
        \ 'fg+': l:base2,
        \ 'bg': -1,
        \ 'bg+': l:yellow,
        \ 'hl': l:blue,
        \ 'hl+': l:cyan,
        \ 'info': l:base2,
        \ 'prompt': l:cyan,
        \ 'pointer': l:base2,
        \ 'marker': l:base02,
        \ 'spinner': l:yellow,
        \ }
  let l:colors = ['dark']
  for l:key in keys(l:color_table)
    call add(l:colors, l:key . ':' . l:color_table[l:key])
  endfor
  return join(l:colors, ',')
endfunction

let s:default_options = {
      \ 'color': s:color_scheme_solarized(),
      \ 'pointer': '>',
      \ 'marker': '"',
      \ 'layout': 'reverse',
      \ 'cycle': v:true,
      \ 'bind': 'ctrl-/:toggle-preview',
      \ 'border': 'none',
      \ 'preview': s:preview,
      \ 'preview-window': 'right,border-left',
      \ }

function! s:merge_options(options, placeholder)
  let l:optdict = deepcopy(s:default_options)
  for l:key in keys(a:options)
    let l:optdict[l:key]  = a:options[l:key]
  endfor

  if has_key(l:optdict, 'no-preview') && l:optdict['no-preview']
    " disable preivew
    call remove(l:optdict, 'preview')
    call remove(l:optdict, 'no-preview')
  endif

  let l:options = []
  for l:key in keys(l:optdict)
    let l:v = l:optdict[l:key]
    if l:key == 'preview'
      let l:v .= ' ' . a:placeholder
    endif

    if type(l:v) == v:t_bool
      if l:v == v:true
        call add(l:options, '--' . l:key)
      endif
    else
      call add(l:options, '--' . l:key . '=' . l:v)
    endif
  endfor
  return l:options
endfunction

"---------------------------------------------------------------------------
" Utilities
"---------------------------------------------------------------------------

let s:ansi = {'black': 30, 'red': 31, 'green': 32, 'yellow': 33, 'blue': 34, 'magenta': 35, 'cyan': 36}

function! s:get_color(attr, ...)
  let gui = has('termguicolors') && &termguicolors
  let fam = gui ? 'gui' : 'cterm'
  let pat = gui ? '^#[a-f0-9]\+' : '^[0-9]\+$'
  for group in a:000
    let code = synIDattr(synIDtrans(hlID(group)), a:attr, fam)
    if code =~? pat
      return code
    endif
  endfor
  return ''
endfunction

function! s:csi(color, fg)
  let prefix = a:fg ? '38;' : '48;'
  if a:color[0] == '#'
    return prefix.'2;'.join(map([a:color[1:2], a:color[3:4], a:color[5:6]], 'str2nr(v:val, 16)'), ';')
  endif
  return prefix.'5;'.a:color
endfunction

function! s:ansi(str, group, default, ...)
  let fg = s:get_color('fg', a:group)
  let bg = s:get_color('bg', a:group)
  let color = (empty(fg) ? s:ansi[a:default] : s:csi(fg, 1)) .
        \ (empty(bg) ? '' : ';'.s:csi(bg, 0))
  return printf("\x1b[%s%sm%s\x1b[m", color, a:0 ? ';1' : '', a:str)
endfunction

for s:color_name in keys(s:ansi)
  execute "function! s:".s:color_name."(str, ...)\n"
        \ "  return s:ansi(a:str, get(a:, 1, ''), '".s:color_name."')\n"
        \ "endfunction"
endfor

function! s:action_for(key, ...)
  let l:default = a:0 ? a:1 : ''
  let l:command = get(get(g:, 'fzf_action', {}), a:key, l:default)
  return type(l:command) == v:t_string ? l:command : l:default
endfunction

function! s:escape(path)
  let l:path = fnameescape(a:path)
  return util#is_windows() ? escape(l:path, '$') : l:path
endfunction

function! s:strip(str)
  return substitute(a:str, '^\s*\|\s*$', '', 'g')
endfunction

function! s:get_git_root() abort
  let l:root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  return v:shell_error ? '' : l:root
endfunction

function! s:prompt(prompt) abort
  let l:max_width = &columns / 2 - 20
  return (strwidth(a:prompt) < l:max_width ? a:prompt : '') . '> '
endfunction

function! s:buflisted()
  return filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&filetype") != "qf"')
endfunction

function! s:sort_buffers(b1, b2)
  let l:bufnr = bufnr()
  if a:b1 == l:bufnr
    return -1
  elseif a:b2 == l:bufnr
    return 1
  end
  return a:b1 < a:b2 ? -1 : 1
endfunction

function! s:buflisted_sorted()
  return sort(s:buflisted(), 's:sort_buffers')
endfunction

function! s:bufopen(lines)
  if len(a:lines) < 2
    return
  endif
  let l:bufnr = matchstr(a:lines[1], '\[\zs[0-9]*\ze\]')
  let l:command = s:action_for(a:lines[0])
  if !empty(l:command)
    execute 'silent' l:command
  endif
  execute 'buffer' l:bufnr
endfunction

function! s:open(cmd, target)
  if stridx('edit', a:cmd) == 0 && fnamemodify(a:target, ':p') ==# expand('%:p')
    normal! m'
    return
  endif
  execute a:cmd s:escape(a:target)
endfunction

function! s:fill_quickfix(list, ...)
  if len(a:list) > 1
    call setqflist(a:list)
    copen
    wincmd p
    if a:0
      execute a:1
    endif
  endif
endfunction

function! s:wrap(name, args, options)
  let l:args = deepcopy(a:args)
  let l:placeholder = has_key(l:args, 'placeholder') ?
        \ remove(l:args, 'placeholder') : '{}'

  let l:options = s:merge_options(a:options, l:placeholder)
  if !has_key(a:options, 'expect') && has_key(l:args, 'sink*')
    let l:Sink = remove(l:args, 'sink*')
    let l:args.options = l:options
    let l:wrapped = fzf#wrap(a:name, l:args)
    let l:wrapped['sink*'] = l:Sink
  else
    let l:args.options = l:options
    let l:wrapped = fzf#wrap(a:name, l:args)
  endif
  return l:wrapped
endfunction

"---------------------------------------------------------------------------
" Files
"---------------------------------------------------------------------------
function! fzf#files(...) abort
  let l:dir = util#normalize_path(get(a:000, 0, getcwd()))
  let l:options = {
        \ 'multi': v:true,
        \ 'prompt': s:prompt(l:dir),
        \ }
  let l:args = {'dir': l:dir}
  return fzf#run(s:wrap('files', l:args, l:options))
endfunction

function! fzf#gitfiles() abort
  return fzf#files(s:get_git_root())
endfunction

function! fzf#history() abort
  let l:recent_files = util#unique(map(
        \ filter([expand('%')], 'len(v:val)')
        \ + filter(map(s:buflisted_sorted(), 'bufname(v:val)'), 'len(v:val)')
        \ + filter(copy(v:oldfiles), 'filereadable(fnamemodify(v:val, ":p"))'),
        \ 'fnamemodify(v:val, ":~:.")'))
  let l:options = {
        \ 'multi': v:true,
        \ 'header-lines': !empty(expand('%')),
        \ 'prompt': s:prompt('History'),
        \ }
  let l:args = {
        \ 'source': l:recent_files,
        \ }
  return fzf#run(s:wrap('history-files', l:args, l:options))
endfunction

"---------------------------------------------------------------------------
" Buffers
"---------------------------------------------------------------------------

function! s:format_buffer(b)
  let name = bufname(a:b)
  let line = exists('*getbufinfo') ? getbufinfo(a:b)[0]['lnum'] : 0
  let name = empty(name) ? '[No Name]' : fnamemodify(name, ":p:~:.")
  let flag = a:b == bufnr('')  ? s:blue('%', 'Conditional') :
          \ (a:b == bufnr('#') ? s:magenta('#', 'Special') : ' ')
  let modified = getbufvar(a:b, '&modified') ? s:red(' [+]', 'Exception') : ''
  let readonly = getbufvar(a:b, '&modifiable') ? '' : s:green(' [RO]', 'Constant')
  let extra = join(filter([modified, readonly], '!empty(v:val)'), '')
  let target = line == 0 ? name : name.':'.line
  return s:strip(printf("%s\t%d\t[%s] %s\t%s\t%s", target, line, s:yellow(a:b, 'Number'), flag, name, extra))
endfunction

function! fzf#buffers()
  let sorted = s:buflisted_sorted()
  let l:options = {
        \ 'header-lines': bufnr('') == get(sorted, 0, 0) ? 1 : 0,
        \ 'no-multi': v:true,
        \ 'extended': v:true,
        \ 'tiebreak': 'index',
        \ 'ansi': v:true,
        \ 'delimiter': '\t',
        \ 'with-nth': '3..',
        \ 'nth': '2,1..2',
        \ 'prompt': s:prompt('Buffers'),
        \ 'tabstop': len(max(sorted)) >= 4 ? 9 : 8,
        \ 'preview-window': '+{2}-/2,right,border-left',
        \ }
  let l:args = {
        \ 'source': map(sorted, 's:format_buffer(v:val)'),
        \ 'sink*': function('s:bufopen'),
        \ 'placeholder': '{1}',
        \ }
  return fzf#run(s:wrap('buffers', l:args, l:options))
endfunction

"---------------------------------------------------------------------------
" Registers
"---------------------------------------------------------------------------

function! s:paste(reg) abort
  execute ':normal ' . split(a:reg, ' ')[2] . 'p'
endfunction

function! fzf#registers() abort
  let l:regs = split(execute(':registers'), '\n')

  " remove header
  let l:header = remove(l:regs, 0)
  let l:options = {
        \ 'ansi': v:true,
        \ 'no-multi': v:true,
        \ 'no-preview': v:true,
        \ 'prompt': s:prompt('Register'),
        \ 'header': l:header,
        \ }
  let l:args = {
        \ 'source': l:regs,
        \ 'sink': function('s:paste'),
        \ }
  call fzf#run(s:wrap('registers', l:args, l:options))
endfunction

"---------------------------------------------------------------------------
" Grep
"---------------------------------------------------------------------------

function! s:grep_to_qf(line, has_column) abort
  let l:parts = matchlist(a:line, '\(.\{-}\)\s*:\s*\(\d\+\)\%(\s*:\s*\(\d\+\)\)\?\%(\s*:\(.*\)\)\?')
  let l:dict = {
        \ 'filename': &acd ? fnamemodify(l:parts[1], ':p') : l:parts[1],
        \ 'lnum': l:parts[2],
        \ 'text': l:parts[4],
        \ }
  if a:has_column
    let l:dict.col = l:parts[3]
  endif
  return l:dict
endfunction

function! s:grep_handler(has_column, lines) abort
  if len(a:lines) < 2
    return
  endif

  let l:cmd = s:action_for(a:lines[0], 'e')
  let l:list = map(filter(a:lines[1:], 'len(v:val)'), 's:grep_to_qf(v:val, a:has_column)')
  if empty(l:list)
    return
  endif

  let l:first = l:list[0]
  try
    call s:open(l:cmd, l:first.filename)
    execute l:first.lnum
    if a:has_column
      call cursor(0, l:first.col)
    endif
    normal! zvzz
  catch
  endtry

  call s:fill_quickfix(list)
endfunction

function! s:grep(name, command, cmdopts, args) abort
  let l:cmdprefix = a:command . ' ' . join(a:cmdopts, ' ') . ' -- %s || true'
  let l:pattern = a:args.pattern
  let l:dir = util#normalize_path(a:args.dir)
  let l:prompt = toupper(a:name[0]) . a:name[1:]
  let l:reload = 'change:reload:' . printf(l:cmdprefix, '{q}')
  let l:options = {
        \ 'ansi': v:true,
        \ 'multi': v:true,
        \ 'prompt': s:prompt(l:prompt),
        \ 'bind': 'alt-a:select-all,alt-d:deselect-all' . ',' . l:reload,
        \ 'delimiter': ':',
        \ 'nth': '-1',
        \ 'preview-window': '+{2}-/2,right,border-left',
        \ }
  let l:has_column = get(a:args, 'column', v:false)
  let l:args = {
        \ 'source': printf(l:cmdprefix, l:pattern),
        \ 'column': l:has_column,
        \ 'dir': l:dir,
        \ 'sink*': function('<SID>grep_handler', [l:has_column]),
        \ }
  return fzf#run(s:wrap(a:name, l:args, l:options))
endfunction

" 0: pattern
" 1: working path
function! fzf#grep(...) abort
  let l:dir = get(a:000, 0, getcwd())
  let l:options = [
        \ '--recursive',
        \ '--ignore-case',
        \ '--line-number',
        \ ]
  let l:excludes = ['.git', '.npm', '.vs', '__pycache__']
  for l:exclude in l:excludes
    call add(l:options, '--exclude-dir=' . l:exclude)
  endfor
  return s:grep('grep', 'grep', l:options, {
        \ 'dir': l:dir,
        \ 'column': v:false,
        \ })
endfunction

" 0: pattern
" 1: working path
function! fzf#gitgrep(...) abort
  let l:pattern = get(a:000, 0, '.*')
  let l:dir = get(a:000, 1, s:get_git_root())
  let l:cmdopts = [
        \ '--column',
        \ '--color=auto',
        \ '--ignore-case',
        \ '--line-number',
        \ '--no-heading',
        \ '--recursive',
        \ '--untracked',
        \ ]
  return s:grep('git-grep', 'git grep', l:cmdopts, {
        \ 'dir': l:dir,
        \ 'column': v:true,
        \ 'pattern': l:pattern,
        \ })
endfunction

" 0: pattern
" 1: working path
function! fzf#ripgrep(query) abort
  " TODO:
  "let l:pattern = get(a:000, 0, '.*')
  "let l:dir = get(a:000, 1, getcwd())
  let l:pattern = shellescape(a:query)
  echom l:pattern
  let l:dir = getcwd()
  let l:cmdopts = [
        \ '--column',
        \ '--line-number',
        \ '--no-heading',
        \ '--color=always',
        \ '--smart-case',
        \ ]
  return s:grep('ripgrep', 'rg', l:cmdopts, {
        \ 'dir': l:dir,
        \ 'column': v:true,
        \ 'pattern': l:pattern,
        \ })
endfunction
