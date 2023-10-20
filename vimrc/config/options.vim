" Options:
"=============================================================================

" General
" -------
set hidden   " 編集中のファイルがあってもバッファを切り替える
set autoread " 外部で内容が更新されたら自動的に読み込む

set fileformat=unix
let &fileencodings = join([
      \ 'utf-8', 'iso-2022-jp', 'sjis', 'cp932',
      \ 'euc-jp', 'utf-16', 'utf-16le'], ',')
let &fileformats = join(['unix', 'dos', 'mac'], ',')

if has('vim_starting')
  set encoding=utf-8
  scriptencoding utf-8
endif

" Fast cliboard setup for macOS
if core#is_mac() && executable('pbcopy') && has('vim_starting')
  let g:clipboard = {
        \   'name': 'macOS-clipboard',
        \   'copy': {
        \     '+': 'pbcopy',
        \     '*': 'pbcopy',
        \   },
        \   'paste': {
        \     '+': 'pbpaste',
        \     '*': 'pbpaste',
        \   },
        \   'cache_enabled': 0,
        \ }
endif

" Use clipboard register.
if has('unnamedplus')
  set clipboard& clipboard+=unnamedplus
else
  set clipboard& clipboard+=unnamed
endif

" Vim Directories
" ---------------
" バックアップファイルを無効
set nobackup
set nowritebackup

set backupdir=$VIM_BACKUP " バックアップファイルの保存先を設定
set directory=$VIM_SWAP   " スワップファイルの保存先を設定
set undodir=$VIM_UNDO     " undo ファイルの保存先を設定

" Disable modeline.
"set modelines=0
"set nomodeline

" Tabs and Indents
" ----------------
set expandtab     " タブを空白に置き換える
set tabstop=2     " タブの画面上での幅
set shiftwidth=2  " 自動インデントでずれる幅
set autoindent    " 新しい行を同じインデント幅を使う
set smartindent   " スマートインデントを有効
set shiftround    " インデントを 'shiftwidth' の倍数に丸める
set softtabstop=2 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅

" Timing
" ------
set updatetime=200 " スワップ書き込みと CursorHold のトリガーとなるアイドルタイム
set timeoutlen=500 " キーコードやマッピングされたキー列が完了するのを待つ時間 (default 1000)

" Searching
" ---------
set ignorecase " 検索時に大文字小文字を無視
set smartcase  " 大文字小文字の両方が含まれている場合は大文字小文字を区別する
set infercase  " 挿入完了モードでの大文字小文字の調整
set incsearch  " インクリメンタルサーチの有効化
set nohlsearch " 検索結果をハイライトしない

if exists('+inccommand')
  set inccommand=nosplit
endif

if executable('rg')
  set grepformat=%f:%l:%c:%m
  let &grepprg =
        \ 'rg --vimgrep --no-heading' .
        \ (&smartcase ? ' --smart-case' : '') .
        \ ' --'
elseif executable('ag')
  set grepformat=%f:%l:%c:%m
  let &grepprg =
        \ 'ag --vimgrep' .
        \ (&smartcase ? ' --smart-case' : '') .
        \ ' --'
endif

" Formatting
" ----------
set wrap                       " 長い行を折り返して表示
set wrapscan                   " ファイル終端でラップする
set backspace=indent,eol,start " バックスペースでインデントや改行を削除できるようにする

let &showbreak='↳  '           " 折り返し行の先頭表示設定

if v:version >= 800
  set breakindent              " 折り返された行と同じインデントで表示する
endif

if exists('&breakindent')
  set breakindentopt=shift:2,min:20
endif

set formatoptions+=mM          " テキスト挿入中の自動折り返しを日本語に対応させる

" Completion and Diff
" -------------------

" キーワード補完の動作を指定
" . カレントバッファから検索 ('wrapscan' の値は無視)
" w 別のウィンドウ内のバッファから検索
" b バッファリスト内の、現在読み込まれている別のバッファから検索
" k 'dictionary' で指定されたファイルから検索
set complete=.,w,b,k

" menuone: 候補が一つしかない場合でもポップアップメニューを使う
" noselect: メニューからマッチを自動では選択せず、ユーザーに自分で選ぶことを
"           強制する
set completeopt=menu,menuone " 一つの項目でも必ずメニューを表示する
if has('patch-7.4.775')
  " メニューからマッチを自動では選択せず、ユーザーに自分で選ぶことを強制する
  set completeopt+=noselect
endif

set diffopt+=iwhite  " Diff mode: 空白を無視する
if has('patch-8.1.0360') || has('nvim-0.5')
  set diffopt+=indent-heuristic,algorithm:patience
endif

" :h jumplist-stack (only Neovim)
if has('nvim-0.5')
  set jumpoptions=stack
endif

" Command-line completion
set wildmenu " コマンドラインで補完するときに強化されたものを使う
if has('wildmenu')
  set wildignorecase
  set wildignore+=.git,.hg,.svn,.stversions,*.pyc,*.spl,*.o,*.out
  set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
  set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*
  set wildignore+=__pycache__,*.egg-info,.pytest_cache,.mypy_cache/**
endif

" Editor UI
" ---------
set title            " タイトルを表示
set scrolloff=2      " カーソルの上下で、最低でも2行表示する
set number           " 行番号を表示
set ruler            " ルーラーを表示 (noruler:非表示)
set nolist           " タブや改行を表示 (list:表示)
set showmatch        " 括弧入力時に対応する括弧を表示

set helpheight=0     " ヘルプウィンドウのリサイズを無効

set showcmd          " コマンドをスタータス行に表示
set cmdheight=1      " コマンドラインの高さ
"set cmdheight=0      " コマンドラインの高さ (使用時のみ表示)
set colorcolumn=79   " 指定列に線を表示する

" 常にステータス行を表示
if has('nvim-0.8')
  set laststatus=3
else
  set laststatus=2
endif

set cursorline     " 行ラインは非表示だが、行番号を色分けする
set showtabline=2    " いつタブページのラベルを表示するかを指定 (2: 常に表示)

" Unicode 曖昧な文字幅の場合の幅を調整
"set ambiwidth=double
set ambiwidth=single

" 目印桁を表示するかどうかを指定する (常に表示)
if exists('&signcolumn')
  set signcolumn=yes
endif

set shortmess=aoOTI  " イントロ表示の抑制

if has('patch-7.4.314')
  " Do not display completion messages
  set shortmess+=c
endif

if has('patch-7.4.1570')
  " Do not display message when editing files
  set shortmess+=F
endif

" GUI
" ---
" Disable menu.vim
if has('gui_running')
  set guioptions=Mc
endif

" vim:set ft=vim sw=2 sts=2 et:
