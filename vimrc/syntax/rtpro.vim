" RTpro syntax file
" Language:	Yamaha ルーターシリーズ 設定ファイル

" Quit when a syntax file was already loaded
if exists('b:current_syntax')
  finish
endif

syntax region rtproComment oneline start='\%(^\|\s\+\)#' end='$' fold
syntax region rtproComment         start='^\s*#' end='^\%(\s*#\)\@!' fold

syntax keyword rtproDefault default contained
" TODO: マスクビット表現がまだ
syntax match rtproIpAddressMaskBits '\d\+\.\d\+\.\d\+\.\d\+' contained
syntax match rtproPPInterface 'pp\s\+\d\+' contained
syntax keyword rtproSwitch on off contained

syntax keyword rtproGateway gateway skipwhite nextgroup=rtproPPInterface

" ip route
syntax match rtproIpRouteCommand '^\s*ip\s\+route' skipwhite
      \ nextgroup=rtproDefault,rtproIpAddressMaskBits
syntax match rtproNoIpRouteCommand '^\s*no\s\+ip\s\+route' skipwhite
      \ nextgroup=rtproDefault,rtproIpAddressMaskBits

" statistics
syntax keyword rtproStatisticsCommand statistics skipwhite
      \ nextgroup=rtproStatisticsType
syntax match rtproNoStatisticsCommand '^\s*no\s\+statistics' skipwhite
      \ nextgroup=rtproStatisticsType
syntax keyword rtproStatisticsType
      \ cpu memory traffic flow nat route filter qos application
      \ skipwhite contained nextgroup=rtproSwitch

highlight def link rtproComment Comment

highlight def link rtproDefault Statement
highlight def link rtproIpAddressMaskBits String
highlight def link rtproSwitch Statement

highlight def link rtproGateway Constant

highlight def link rtproIpRouteCommand Type
highlight def link rtproNoIpRouteCommand Error
highlight def link rtproStatisticsCommand Type

highlight def link rtproStatisticsCommand Type
highlight def link rtproNoStatisticsCommand Error
highlight def link rtproStatisticsType Constant

let b:current_syntax = 'rtpro'
