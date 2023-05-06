" vimplug.vim
"=============================================================================

let s:plugins_dir = expand('$CONFIG_PATH/plugins')

if core#is_windows()
  " For Windows
  function! s:install_command(url, path)
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
else
  " For Unix(Linux) and MacOS
  function! s:install_command(url, path)
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
endif

function! vimplug#install(data_path) abort
  " Install vim-plug
  let l:url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  for l:path in [s:vim_plug, s:nvim_plug]
    if filereadable(l:path)
      continue
    endif

    let l:dir = fnamemodify(l:path, ':h')
    call core#mkdir(l:dir)

    try
      echohl WarningMsg
      echo printf('Install vim-plug to "%s" ... ', l:path)
      call execute(s:install_command(l:url, l:path))
      echon '[Done]'
    finally
      echohl None
    endtry
  endfor
endfunction

function! vimplug#begin() abort
  call plug#begin(s:plugins_dir)
endfunction

function! vimplug#end() abort
  call plug#end()
endfunction

function! vimplug#tap(name)
  return isdirectory(s:plugins_dir . '/' . a:name)
endfunction
