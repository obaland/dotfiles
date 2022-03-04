" Options:
"=============================================================================

" Setting of the encoding to use for a save and reading.
" Make it normal in UTF-8 in Unix.
set encoding=utf-8
scriptencoding utf-8

"-----------------------------------------------------------------------------
" Search:
"-----------------------------------------------------------------------------
" 検索時に大文字小文字を無視
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別する
set smartcase
" インクリメンタルサーチの有効化
set incsearch
" 検索結果をハイライトしない
set nohlsearch
" ファイル終端でラップする
set wrapscan

"-----------------------------------------------------------------------------
" Edit:
"-----------------------------------------------------------------------------
" タブの画面上での幅
set tabstop=2
" タブを空白に置き換える
set expandtab
" スマートインデントを有効
set autoindent smartindent
" 自動インデントでずれる値
set shiftwidth=2
" 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set softtabstop=2
" 折り返し行の先頭表示設定
set showbreak=[+]\

if v:version >= 800
  " 同一行で画面幅に収まらない場合の折り返しにインデントする
  set breakindent
endif

" Disable modeline.
"set modelines=0
"set nomodeline

" Use clipboard register.
if has('unnamedplus')
  set clipboard& clipboard+=unnamedplus
else
  set clipboard& clipboard+=unnamed
endif

" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
" 括弧入力時に対応する括弧を表示
set showmatch
" コマンドラインで補完するときに強化されたものを使う
set wildmenu
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM

"-----------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:
"-----------------------------------------------------------------------------
" 行番号を表示
set number
" 行ラインは非表示だが、行番号を色分けする
set cursorline
" 指定列に線を表示する
set colorcolumn=79

" 目印桁を表示するかどうかを指定する (常に表示)
set signcolumn=yes

" ルーラーを表示 (noruler:非表示)
set ruler
" タブや改行を表示 (list:表示)
set nolist
" 長い行を折り返して表示
set wrap
" 常にステータス行を表示
set laststatus=2
" コマンドラインの高さ
set cmdheight=2
" コマンドをスタータス行に表示
set showcmd
" タイトルを表示
set title
" イントロ表示の抑制
set shortmess+=cI
" Unicode 曖昧な文字幅の場合の幅を調整
"set ambiwidth=double
set ambiwidth=single
" 外部で内容が更新されたら自動的に読み込む
set autoread
" Check timestamp more for 'autoread'.
autocmd MyAutoCmd WinEnter * checktime

"-----------------------------------------------------------------------------
" ファイル操作に関する設定:
"-----------------------------------------------------------------------------
" バックアップファイルを無効
set nobackup
set nowritebackup

" バックアップファイルの保存先を設定
set backupdir=$TMPFILES
" スワップファイルの保存先を設定
set directory=$TMPFILES
" undo ファイルの保存先を設定
set undodir=$UNDOFILES

"-----------------------------------------------------------------------------
" Buffer:
"-----------------------------------------------------------------------------
" 編集中のファイルがあってもバッファを切り替える
set hidden

"-----------------------------------------------------------------------------
" Other:
"-----------------------------------------------------------------------------
set updatetime=300

"---------------------------------------------------------------------------
" 補完に関する設定:
"
" menuone: 候補が一つしかない場合でもポップアップメニューを使う
" noselect: メニューからマッチを自動では選択せず、ユーザーに自分で選ぶことを
"           強制する
set completeopt=menuone,noselect
