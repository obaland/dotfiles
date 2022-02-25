"-----------------------------------------------------------------------------
" vimplug.rc.vim
"-----------------------------------------------------------------------------

let s:url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

function! s:install(path, command)
  if filereadable(a:path)
    return
  endif

  let l:dir = fnamemodify(a:path, ':h')
  call MakeDirectory(l:dir)

  try
    echohl WarningMsg
    echo printf('Install vim-plug to "%s" ... ', a:path)
    call execute(a:command)
    echon '[Done]'
  finally
    echohl None
  endtry
endfunction

if IsWindows()
  " For Windows
  function! s:command(url, path)
    return printf(
          \ '!bitsadmin /transfer "vimplug" %s %s',
          \ a:url, shellescape(a:path)
          \ )
  endfunction

  let s:vim_plug = expand('~\vimfiles\autoload\plug.vim')

  let s:nvim_plug = expand($XDG_DATA_HOME)
  if !isdirectory(s:nvim_plug)
    let s:nvim_plug = expand($LOCALAPPDATA)
  endif
  let s:nvim_plug .= '\nvim-data\site\autoload\plug.vim'

  let paths = [s:vim_plug, s:nvim_plug]
else
  " For Unix(Linux) and MacOS
  function! s:command(url, path)
    return printf(
          \ '!curl -fLo %s --create-dirs %s', shellescape(a:path), a:url
          \ )
  endfunction

  let s:vim_plug = expand('~/.vim/autoload/plug.vim')

  let s:nvim_plug = expand($XDG_DATA_HOME)
  if !isdirectory(s:nvim_plug)
    let s:nvim_plug = expand('~/.local/share')
  endif
  let s:nvim_plug .= '/nvim/site/autoload/plug.vim'

  let paths = [s:vim_plug, s:nvim_plug]
endif

" Install
for path in paths
  let command = s:command(s:url, path)
  call s:install(path, command)
endfor
