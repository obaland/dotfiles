"-----------------------------------------------------------------------------
" Define commands
"-----------------------------------------------------------------------------

scriptencoding utf-8

" カレントバッファディレクトリへの cd コマンド
command! -nargs=0 Ccd cd %:h
command! -nargs=0 Lccd lcd %:h

" ファイル操作
" エンコード変換
command! -nargs=0 EncodeUTF8 set fileencoding=utf-8
command! -nargs=0 EncodeCP932 set fileencoding=cp932
command! -nargs=0 EncodeSJIS set fileencoding=sjis
command! -nargs=0 ReloadEncodeUTF8 edit ++enc=utf-8
command! -nargs=0 ReloadEncodeCP932 edit ++enc=cp932
command! -nargs=0 ReloadEncodeSJIS edit ++enc=sjis

" ファイルフォーマット変換
command! -nargs=0 FileFormatUnix set fileformat=unix
command! -nargs=0 FileFormatDos set fileformat=dos
command! -nargs=0 ReloadFileFormatUnix edit ++ff=unix
command! -nargs=0 ReloadFileFormatDos edit ++ff=dos

" ユーティリティ
" 行末の空白文字を削除する
command! -nargs=0 TrimSpace %s/\s\+$//ge

" ハイライト確認
command! -nargs=0 ShowHighlightGroup
      \ echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
command! -nargs=0 ShowHighlightItem
      \ echom synIDattr(synID(line('.'), col('.'), 1), 'name')

" セッション関連
function! s:make_session(name)
  execute 'silent mksession! ' . $SESSIONFILES . '/' . a:name . '.vim'
endfunction

function! s:load_session(name)
  execute 'silent source ' . $SESSIONFILES . '/' . a:name . '.vim'
endfunction

command! -nargs=1 MakeSession call s:make_session(<f-args>)
command! -nargs=1 LoadSession call s:load_session(<f-args>)
