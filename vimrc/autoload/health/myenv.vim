" myenv.vim
"=============================================================================

function! s:check_command(command) abort
  let l:msg = a:command.name . ' [' . a:command.desc . ']'
  if executable(a:command.name)
    call health#report_ok(
          \ printf('%s - Executable (%s)', a:command.name, exepath(a:command.name))
          \ )
    return v:true
  endif

  let l:guide = core#is_windows() ? a:command.guide_win :
        \ has('mac') ? a:command.guide_mac : a:command.guide_unix
  call health#report_warn(
        \ printf('%s - Not Executable', a:command.name),
        \ [ a:command.desc, printf('Please install. (e.g. %s)', l:guide) ]
        \ )
  return v:false
endfunction

function! s:check_required() abort
  " git command
  let l:git = {
        \ 'name': 'git',
        \ 'desc': 'Version control system',
        \ 'guide_win': 'choco install git',
        \ 'guide_mac': 'brew install git',
        \ 'guide_unix': 'apt install git',
        \ }
  call s:check_command(l:git)
endfunction

function! s:check_configuration() abort
  let l:configs = {}

  if has('nvim') && core#is_windows()
    let l:configs['$VIM_PYTHON_PROG_ROOT'] = 'the Root direcotry path of python2 executable program.'
    let l:configs['$VIM_PYTHON3_PROG_ROOT'] = 'the Root direcotry path of python3 executable program.'
  endif

  for l:config in items(l:configs)
    let l:msg = l:config[0] . ' [' . l:config[1] . ']'
    if exists(l:config[0])
      call health#report_ok(
            \ printf('%s - Set (%s)', l:config[0], expand(l:config[0]))
            \ )
    else
      call health#report_warn(
            \ printf('%s - Not set', l:config[0]),
            \ [ l:config[1] ]
            \ )
    endif
  endfor
endfunction

function! s:check_commands() abort
  let l:commands = []

  " ripgrep
  let l:ripgrep = {
        \ 'name': 'rg',
        \ 'desc': 'ripgrep combines the usability of The Silver Searcher with the raw speed of grep',
        \ 'guide_win': 'choco install ripgrep',
        \ 'guide_mac': 'brew install ripgrep',
        \ 'guide_unix': 'apt install ripgrep',
        \ }
  call add(l:commands, l:ripgrep)

  " The Silver Searcher
  let l:ag = {
        \ 'name': 'ag',
        \ 'desc': 'The Silver Searcher is like grep or ack, except faster',
        \ 'guide_win': 'choco install ag',
        \ 'guide_mac': 'brew install ag',
        \ 'guide_unix': 'apt install silversearcher-ag',
        \ }
  if !executable(l:ripgrep.name)
    call add(l:commands, l:ag)
  endif

  for l:command in l:commands
    call s:check_command(l:command)
  endfor
endfunction

function! health#myenv#check() abort
  let l:checks = {
        \ 'Required': 's:check_required',
        \ 'Configuration': 's:check_configuration',
        \ 'Command': 's:check_commands'
        \ }

  for l:check in items(l:checks)
    call health#report_start(l:check[0])
    execute('call ' . l:check[1] . '()')
  endfor
endfunction

" vim:set ft=vim sw=2 sts=2 et:
