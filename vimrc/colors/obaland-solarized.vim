" Name: obaland-solarized
" See: https://ethanschoonover.com/solarized/

" ---------------------------------------------------------------------
" COLOR VALUES
" ---------------------------------------------------------------------
" Download palettes and files from: http://ethanschoonover.com/solarized
"
" L\*a\*b values are canonical (White D65, Reference D50), other values are
" matched in sRGB space.
"
" SOLARIZED HEX     16/8 TERMCOL  XTERM/HEX   L*A*B      sRGB        HSB
" --------- ------- ---- -------  ----------- ---------- ----------- -----------
" base03    #002b36  8/4 brblack  234 #1c1c1c 15 -12 -12   0  43  54 193 100  21
" base02    #073642  0/4 black    235 #262626 20 -12 -12   7  54  66 192  90  26
" base01    #586e75 10/7 brgreen  240 #4e4e4e 45 -07 -07  88 110 117 194  25  46
" base00    #657b83 11/7 bryellow 241 #585858 50 -07 -07 101 123 131 195  23  51
" base0     #839496 12/6 brblue   244 #808080 60 -06 -03 131 148 150 186  13  59
" base1     #93a1a1 14/4 brcyan   245 #8a8a8a 65 -05 -02 147 161 161 180   9  63
" base2     #eee8d5  7/7 white    254 #d7d7af 92 -00  10 238 232 213  44  11  93
" base3     #fdf6e3 15/7 brwhite  230 #ffffd7 97  00  10 253 246 227  44  10  99
" yellow    #b58900  3/3 yellow   136 #af8700 60  10  65 181 137   0  45 100  71
" orange    #cb4b16  9/3 brred    166 #d75f00 50  50  55 203  75  22  18  89  80
" red       #dc322f  1/1 red      160 #d70000 50  65  45 220  50  47   1  79  86
" magenta   #d33682  5/5 magenta  125 #af005f 50  65 -05 211  54 130 331  74  83
" violet    #6c71c4 13/5 brmagenta 61 #5f5faf 50  15 -45 108 113 196 237  45  77
" blue      #268bd2  4/4 blue      33 #0087ff 55 -10 -45  38 139 210 205  82  82
" cyan      #2aa198  6/6 cyan      37 #00afaf 60 -35 -05  42 161 152 175  74  63
" green     #859900  2/2 green     64 #5f8700 60 -20  65 133 153   0  68 100  60

" Font styles:
let g:solarized_contrast = get(g:, 'solarized_contrast', 'normal')
let g:solarized_termtrans = get(g:, 'solarized_termtrans', 0)

" Colorscheme initialization
" --------------------------
highlight clear
if exists('syntax_on')
  syntax reset
endif
let colors_name = 'obaland-solarized'

" Hexadecimal palettes
" --------------------
" Set gui and terminal at the same time.
let s:gui_mode    = 'gui'
let s:gui_base03  = '#002b36'
let s:gui_base02  = '#073642'
let s:gui_base01  = '#586e75'
let s:gui_base00  = '#657b83'
let s:gui_base0   = '#839496'
let s:gui_base1   = '#93a1a1'
let s:gui_base2   = '#eee8d5'
let s:gui_base3   = '#fdf6e3'
let s:gui_yellow  = '#b58900'
let s:gui_orange  = '#cb4b16'
let s:gui_red     = '#dc322f'
let s:gui_magenta = '#d33682'
let s:gui_violet  = '#6c71c4'
let s:gui_blue    = '#268bd2'
let s:gui_cyan    = '#2aa198'
let s:gui_green   = '#719e07' " experimental
let s:gui_white   = '#d7d7bc' " experimental
let s:gui_rose    = '#e95464' " experimental

let s:term_mode    = 'cterm'
let s:term_base03  = '8'
let s:term_base02  = '0'
let s:term_base01  = '10'
let s:term_base00  = '11'
let s:term_base0   = '12'
let s:term_base1   = '14'
let s:term_base2   = '7'
let s:term_base3   = '15'
let s:term_yellow  = '3'
let s:term_orange  = '9'
let s:term_red     = '1'
let s:term_magenta = '5'
let s:term_violet  = '13'
let s:term_blue    = '4'
let s:term_cyan    = '6'
let s:term_green   = '2'
let s:term_white   = '7'
let s:term_rose    = '1'

" Original colors
let s:gui_dark0 ='#222436'
let s:gui_dark0_hl ='#2f334d'
let s:gui_dark1 ='#24283b'
let s:gui_dark1_hl ='#292e42'
let s:gui_dark2 ='#414868'
let s:gui_dark3 ='#444a73'
let s:gui_dark4 ='#545c7e'
let s:gui_dark5 ='#737aa2'
let s:gui_dark6 ='#828bb8'
let s:gui_dark7 ='#a9b1d6'
let s:gui_gutter ='#3b4261'
let s:gui_darkblue ='#394b70'
let s:gui_navyblue ='#202f55'
let s:gui_indigo ='#043c78'
let s:gui_marineblue ='#006888'
let s:gui_madonnablue ='#00608d'
let s:gui_ultramarine ='#434da2'

let s:term_dark0 ='0'
let s:term_dark0_hl ='8'
let s:term_dark1 ='0'
let s:term_dark1_hl ='8'
let s:term_dark2 ='0'
let s:term_dark3 ='0'
let s:term_dark4 ='5'
let s:term_dark5 ='5'
let s:term_dark6 ='5'
let s:term_dark7 ='5'
let s:term_gutter ='5'
let s:term_darkblue = '4'
let s:term_navyblue = '4'
let s:term_indigo ='4'
let s:term_ultramarine ='4'

" Formatting options and null values for passthrough effect
" ---------------------------------------------------------
let s:gui_none  = 'NONE'
let s:term_none = 'NONE'
let s:n         = 'NONE'
let s:c         = ',undercurl'
let s:r         = ',reverse'
let s:s         = ',standout'
let s:ou        = ''
let s:ob        = ''

" Background value based on termtrans setting
" -------------------------------------------
if (has('gui_running') || g:solarized_termtrans == 0)
  let s:gui_back  = s:gui_base03
  let s:term_back = s:term_base03
else
  let s:gui_back  = 'NONE'
  let s:term_back = 'NONE'
endif

" Alternate light scheme
" ----------------------
function! s:alternate_light_scheme() abort
	" GUI
	let l:gui_temp03 = s:gui_base03
	let l:gui_temp02 = s:gui_base02
	let l:gui_temp01 = s:gui_base01
	let l:gui_temp00 = s:gui_base00
	let s:gui_base03 = s:gui_base3
	let s:gui_base02 = s:gui_base2
	let s:gui_base01 = s:gui_base1
	let s:gui_base00 = s:gui_base0
	let s:gui_base0  = l:gui_temp00
	let s:gui_base1  = l:gui_temp01
	let s:gui_base2  = l:gui_temp02
	let s:gui_base3  = l:gui_temp03
	if s:gui_back != 'NONE'
		let s:gui_back = s:gui_base03
	endif

	" terminal
	let l:term_temp03 = s:term_base03
	let l:term_temp02 = s:term_base02
	let l:term_temp01 = s:term_base01
	let l:term_temp00 = s:term_base00
	let s:term_base03 = s:term_base3
	let s:term_base02 = s:term_base2
	let s:term_base01 = s:term_base1
	let s:term_base00 = s:term_base0
	let s:term_base0  = l:term_temp00
	let s:term_base1  = l:term_temp01
	let s:term_base2  = l:term_temp02
	let s:term_base3  = l:term_temp03
	if s:term_back != 'NONE'
		let s:term_back = s:term_base03
	endif
endfunction

if &background == 'light'
	call s:alternate_light_scheme()
endif

" Optional contrast schemes
" -------------------------
if g:solarized_contrast == 'high'
  let s:gui_base01 = s:gui_base00
  let s:gui_base00 = s:gui_base0
  let s:gui_base0  = s:gui_base1
  let s:gui_base1  = s:gui_base2
  let s:gui_base2  = s:gui_base3
  let s:gui_back   = s:gui_back

  let s:term_base01 = s:term_base00
  let s:term_base00 = s:term_base0
  let s:term_base0  = s:term_base1
  let s:term_base1  = s:term_base2
  let s:term_base2  = s:term_base3
  let s:term_back   = s:term_back
endif
if g:solarized_contrast == 'low'
  let s:gui_back  = s:gui_base02
  let s:term_back = s:term_base02
  let s:ou        = ',underline'
endif

" Overrides dependent on user specified values and environment
" ------------------------------------------------------------
let s:b = ',bold'
let s:u = ',underline'
let s:i = ',italic'

" Highlighting primitives
" -----------------------
execute 'let s:bg_none    = " ' . 'guibg='.s:gui_none    . ' ctermbg='.s:term_none    . '"'
execute 'let s:bg_back    = " ' . 'guibg='.s:gui_back    . ' ctermbg='.s:term_back    . '"'
execute 'let s:bg_base03  = " ' . 'guibg='.s:gui_base03  . ' ctermbg='.s:term_base03  . '"'
execute 'let s:bg_base02  = " ' . 'guibg='.s:gui_base02  . ' ctermbg='.s:term_base02  . '"'
execute 'let s:bg_base01  = " ' . 'guibg='.s:gui_base01  . ' ctermbg='.s:term_base01  . '"'
execute 'let s:bg_base00  = " ' . 'guibg='.s:gui_base00  . ' ctermbg='.s:term_base00  . '"'
execute 'let s:bg_base0   = " ' . 'guibg='.s:gui_base0   . ' ctermbg='.s:term_base0   . '"'
execute 'let s:bg_base1   = " ' . 'guibg='.s:gui_base1   . ' ctermbg='.s:term_base1   . '"'
execute 'let s:bg_base2   = " ' . 'guibg='.s:gui_base2   . ' ctermbg='.s:term_base2   . '"'
execute 'let s:bg_base3   = " ' . 'guibg='.s:gui_base3   . ' ctermbg='.s:term_base3   . '"'
execute 'let s:bg_green   = " ' . 'guibg='.s:gui_green   . ' ctermbg='.s:term_green   . '"'
execute 'let s:bg_yellow  = " ' . 'guibg='.s:gui_yellow  . ' ctermbg='.s:term_yellow  . '"'
execute 'let s:bg_orange  = " ' . 'guibg='.s:gui_orange  . ' ctermbg='.s:term_orange  . '"'
execute 'let s:bg_red     = " ' . 'guibg='.s:gui_red     . ' ctermbg='.s:term_red     . '"'
execute 'let s:bg_magenta = " ' . 'guibg='.s:gui_magenta . ' ctermbg='.s:term_magenta . '"'
execute 'let s:bg_violet  = " ' . 'guibg='.s:gui_violet  . ' ctermbg='.s:term_violet  . '"'
execute 'let s:bg_blue    = " ' . 'guibg='.s:gui_blue    . ' ctermbg='.s:term_blue    . '"'
execute 'let s:bg_cyan    = " ' . 'guibg='.s:gui_cyan    . ' ctermbg='.s:term_cyan    . '"'
execute 'let s:bg_white   = " ' . 'guibg='.s:gui_white   . ' ctermbg='.s:term_white   . '"'
execute 'let s:bg_rose    = " ' . 'guibg='.s:gui_rose    . ' ctermbg='.s:term_rose    . '"'

execute 'let s:fg_none    = " ' . 'guifg='.s:gui_none    . ' ctermfg='.s:term_none    . '"'
execute 'let s:fg_back    = " ' . 'guifg='.s:gui_back    . ' ctermfg='.s:term_back    . '"'
execute 'let s:fg_base03  = " ' . 'guifg='.s:gui_base03  . ' ctermfg='.s:term_base03  . '"'
execute 'let s:fg_base02  = " ' . 'guifg='.s:gui_base02  . ' ctermfg='.s:term_base02  . '"'
execute 'let s:fg_base01  = " ' . 'guifg='.s:gui_base01  . ' ctermfg='.s:term_base01  . '"'
execute 'let s:fg_base00  = " ' . 'guifg='.s:gui_base00  . ' ctermfg='.s:term_base00  . '"'
execute 'let s:fg_base0   = " ' . 'guifg='.s:gui_base0   . ' ctermfg='.s:term_base0   . '"'
execute 'let s:fg_base1   = " ' . 'guifg='.s:gui_base1   . ' ctermfg='.s:term_base1   . '"'
execute 'let s:fg_base2   = " ' . 'guifg='.s:gui_base2   . ' ctermfg='.s:term_base2   . '"'
execute 'let s:fg_base3   = " ' . 'guifg='.s:gui_base3   . ' ctermfg='.s:term_base3   . '"'
execute 'let s:fg_green   = " ' . 'guifg='.s:gui_green   . ' ctermfg='.s:term_green   . '"'
execute 'let s:fg_yellow  = " ' . 'guifg='.s:gui_yellow  . ' ctermfg='.s:term_yellow  . '"'
execute 'let s:fg_orange  = " ' . 'guifg='.s:gui_orange  . ' ctermfg='.s:term_orange  . '"'
execute 'let s:fg_red     = " ' . 'guifg='.s:gui_red     . ' ctermfg='.s:term_red     . '"'
execute 'let s:fg_magenta = " ' . 'guifg='.s:gui_magenta . ' ctermfg='.s:term_magenta . '"'
execute 'let s:fg_violet  = " ' . 'guifg='.s:gui_violet  . ' ctermfg='.s:term_violet  . '"'
execute 'let s:fg_blue    = " ' . 'guifg='.s:gui_blue    . ' ctermfg='.s:term_blue    . '"'
execute 'let s:fg_cyan    = " ' . 'guifg='.s:gui_cyan    . ' ctermfg='.s:term_cyan    . '"'
execute 'let s:fg_white   = " ' . 'guifg='.s:gui_white   . ' ctermfg='.s:term_white   . '"'
execute 'let s:fg_rose    = " ' . 'guifg='.s:gui_rose    . ' ctermfg='.s:term_rose    . '"'

execute 'let s:fmt_none  = " ' . 'gui=NONE'         . ' cterm=NONE'         . '"'
execute 'let s:fmt_bold  = " ' . 'gui=NONE'.s:b     . ' cterm=NONE'.s:b     . '"'
execute 'let s:fmt_bolu  = " ' . 'gui=NONE'.s:b.s:u . ' cterm=NONE'.s:b.s:u . '"'
execute 'let s:fmt_bldi  = " ' . 'gui=NONE'.s:b     . ' cterm=NONE'.s:b     . '"'
execute 'let s:fmt_undr  = " ' . 'gui=NONE'.s:u     . ' cterm=NONE'.s:u     . '"'
execute 'let s:fmt_curl  = " ' . 'gui=NONE'.s:c     . ' cterm=NONE'.s:c     . '"'
execute 'let s:fmt_ital  = " ' . 'gui=NONE'.s:i     . ' cterm=NONE'.s:i     . '"'
execute 'let s:fmt_stnd  = " ' . 'gui=NONE'.s:s     . ' cterm=NONE'.s:s     . '"'
execute 'let s:fmt_revr  = " ' . 'gui=NONE'.s:r     . ' cterm=NONE'.s:r     . '"'
execute 'let s:fmt_revb  = " ' . 'gui=NONE'.s:r.s:b . ' cterm=NONE'.s:r.s:b . '"'
execute 'let s:fmt_revbu = " ' . 'gui=NONE'.s:r.s:b.s:u . ' cterm=NONE'.s:r.s:b.s:u . '"'

if has('gui_running') || has('termguicolors') && &termguicolors
  execute 'let s:sp_none    = " guisp=' . s:gui_none    . '"'
  execute 'let s:sp_back    = " guisp=' . s:gui_back    . '"'
  execute 'let s:sp_base03  = " guisp=' . s:gui_base03  . '"'
  execute 'let s:sp_base02  = " guisp=' . s:gui_base02  . '"'
  execute 'let s:sp_base01  = " guisp=' . s:gui_base01  . '"'
  execute 'let s:sp_base00  = " guisp=' . s:gui_base00  . '"'
  execute 'let s:sp_base0   = " guisp=' . s:gui_base0   . '"'
  execute 'let s:sp_base1   = " guisp=' . s:gui_base1   . '"'
  execute 'let s:sp_base2   = " guisp=' . s:gui_base2   . '"'
  execute 'let s:sp_base3   = " guisp=' . s:gui_base3   . '"'
  execute 'let s:sp_green   = " guisp=' . s:gui_green   . '"'
  execute 'let s:sp_yellow  = " guisp=' . s:gui_yellow  . '"'
  execute 'let s:sp_orange  = " guisp=' . s:gui_orange  . '"'
  execute 'let s:sp_red     = " guisp=' . s:gui_red     . '"'
  execute 'let s:sp_magenta = " guisp=' . s:gui_magenta . '"'
  execute 'let s:sp_violet  = " guisp=' . s:gui_violet  . '"'
  execute 'let s:sp_blue    = " guisp=' . s:gui_blue    . '"'
  execute 'let s:sp_cyan    = " guisp=' . s:gui_cyan    . '"'
else
	let s:sp_none    = ''
	let s:sp_back    = ''
	let s:sp_base03  = ''
	let s:sp_base02  = ''
	let s:sp_base01  = ''
	let s:sp_base00  = ''
	let s:sp_base0   = ''
	let s:sp_base1   = ''
	let s:sp_base2   = ''
	let s:sp_base3   = ''
	let s:sp_green   = ''
	let s:sp_yellow  = ''
	let s:sp_orange  = ''
	let s:sp_red     = ''
	let s:sp_magenta = ''
	let s:sp_violet  = ''
	let s:sp_blue    = ''
	let s:sp_cyan    = ''
endif

execute 'let s:fg_dark0    = " ' . 'guifg='.s:gui_dark0    . ' ctermfg='.s:term_dark0    . '"'
execute 'let s:fg_dark0_hl = " ' . 'guifg='.s:gui_dark0_hl . ' ctermfg='.s:term_dark0_hl . '"'
execute 'let s:fg_dark1    = " ' . 'guifg='.s:gui_dark1    . ' ctermfg='.s:term_dark1    . '"'
execute 'let s:fg_dark1_hl = " ' . 'guifg='.s:gui_dark1_hl . ' ctermfg='.s:term_dark1_hl . '"'
execute 'let s:fg_dark2    = " ' . 'guifg='.s:gui_dark2    . ' ctermfg='.s:term_dark2    . '"'
execute 'let s:fg_dark3    = " ' . 'guifg='.s:gui_dark3    . ' ctermfg='.s:term_dark3    . '"'
execute 'let s:fg_dark4    = " ' . 'guifg='.s:gui_dark4    . ' ctermfg='.s:term_dark4    . '"'
execute 'let s:fg_dark5    = " ' . 'guifg='.s:gui_dark5    . ' ctermfg='.s:term_dark5    . '"'
execute 'let s:fg_dark6    = " ' . 'guifg='.s:gui_dark6    . ' ctermfg='.s:term_dark6    . '"'
execute 'let s:fg_dark7    = " ' . 'guifg='.s:gui_dark7    . ' ctermfg='.s:term_dark7    . '"'
execute 'let s:fg_gutter   = " ' . 'guifg='.s:gui_gutter   . ' ctermfg='.s:term_gutter   . '"'
execute 'let s:fg_darkblue = " ' . 'guifg='.s:gui_darkblue . ' ctermfg='.s:term_darkblue . '"'
execute 'let s:fg_indigo   = " ' . 'guifg='.s:gui_indigo   . ' ctermfg='.s:term_indigo   . '"'
execute 'let s:fg_navyblue = " ' . 'guifg='.s:gui_navyblue . ' ctermfg='.s:term_navyblue . '"'
execute 'let s:fg_ultramarine = " ' . 'guifg='.s:gui_ultramarine . ' ctermfg='.s:term_ultramarine . '"'

execute 'let s:bg_dark0_hl = " ' . 'guibg='.s:gui_dark0_hl . ' ctermbg='.s:term_dark0_hl . '"'

" Basic highlighting

execute 'highlight! Normal'     .s:fmt_none .s:fg_base0  .s:bg_back
execute 'highlight! Comment'    .s:fmt_none .s:fg_base01 .s:bg_none
execute 'highlight! Constant'   .s:fmt_none .s:fg_cyan   .s:bg_none
execute 'highlight! Identifier' .s:fmt_none .s:fg_blue   .s:bg_none
execute 'highlight! Statement'  .s:fmt_none .s:fg_green  .s:bg_none
execute 'highlight! PreProc'    .s:fmt_none .s:fg_orange .s:bg_none
execute 'highlight! Type'       .s:fmt_none .s:fg_yellow .s:bg_none
execute 'highlight! Special'    .s:fmt_none .s:fg_red    .s:bg_none
execute 'highlight! Underlined' .s:fmt_none .s:fg_violet .s:bg_none
execute 'highlight! Ignore'     .s:fmt_none .s:fg_none   .s:bg_none
execute 'highlight! Error'      .s:fmt_none .s:fg_red    .s:bg_none
execute 'highlight! Todo'       .s:fmt_none .s:fg_magenta.s:bg_none

"       *Constant        any constant
"        String          a string constant: "this is a string"
"        Character       a character constant: 'c', '\n'
"        Number          a number constant: 234, 0xff
"        Boolean         a boolean constant: TRUE, false
"        Float           a floating point constant: 2.3e10

"       *Identifier      any variable name
"        Function        function name (also: methods for classes)

"       *Statement       any statement
"        Conditional     if, then, else, endif, switch, etc.
"        Repeat          for, do, while, etc.
"        Label           case, default, etc.
"        Operator        "sizeof", "+", "*", etc.
"        Keyword         any other keyword
"        Exception       try, catch, throw

"       *PreProc         generic Preprocessor
"        Include         preprocessor #include
"        Define          preprocessor #define
"        Macro           same as Define
"        PreCondit       preprocessor #if, #else, #endif, etc.

"       *Type            int, long, char, etc.
"        StorageClass    static, register, volatile, etc.
"        Structure       struct, union, enum, etc.
"        Typedef         A typedef

"       *Special         any special symbol
"        SpecialChar     special character in a constant
"        Tag             you can use CTRL-] on this
"        Delimiter       character that needs attention
"        SpecialComment  special things inside a comment
"        Debug           debugging statements

"       *Todo            anything that needs extra attention; mostly the
"                        keywords TODO FIXME and XXX

" Extended highlighting
" ---------------------
execute 'highlight! Directory'    .s:fmt_none .s:fg_blue   .s:bg_none
execute 'highlight! ErrorMsg'     .s:fmt_revr .s:fg_red    .s:bg_none
execute 'highlight! FoldColumn'   .s:fmt_none .s:fg_base0  .s:bg_base02
execute 'highlight! Folded'       .s:fmt_none .s:fg_base0  .s:bg_base02 .s:sp_base03
execute 'highlight! IncSearch'    .s:fmt_stnd .s:fg_orange .s:bg_none
execute 'highlight! LineNr'       .s:fmt_none .s:fg_base01 .s:bg_base02
execute 'highlight! ModeMsg'      .s:fmt_none .s:fg_blue   .s:bg_none
execute 'highlight! MoreMsg'      .s:fmt_none .s:fg_blue   .s:bg_none
execute 'highlight! NonText'      .s:fmt_none .s:fg_base00 .s:bg_none
execute 'highlight! Question'     .s:fmt_none .s:fg_cyan   .s:bg_none
execute 'highlight! Search'       .s:fmt_revr .s:fg_yellow .s:bg_none
execute 'highlight! SpecialKey'   .s:fmt_none .s:fg_base00 .s:bg_base02
execute 'highlight! StatusLine'   .s:fmt_none .s:fg_base1  .s:bg_base02 .s:fmt_revb
execute 'highlight! StatusLineNC' .s:fmt_none .s:fg_base00 .s:bg_base02 .s:fmt_revb
execute 'highlight! Title'        .s:fmt_none .s:fg_orange .s:bg_none
execute 'highlight! VertSplit'    .s:fmt_none .s:fg_base00 .s:bg_none
execute 'highlight! Variable'     .s:fmt_none .s:fg_base1  .s:bg_none
execute 'highlight! Visual'       .s:fmt_none .s:fg_base01 .s:bg_base03 .s:fmt_revb
execute 'highlight! VisualNOS'    .s:fmt_stnd .s:fg_none   .s:bg_base02 .s:fmt_revb
execute 'highlight! WarningMsg'   .s:fmt_none .s:fg_red    .s:bg_none
execute 'highlight! WildMenu'     .s:fmt_none .s:fg_base2  .s:bg_base02 .s:fmt_revb

execute 'highlight! DiffAdd'      .s:fmt_none .s:fg_green  .s:bg_base02 .s:sp_green
execute 'highlight! DiffChange'   .s:fmt_none .s:fg_yellow .s:bg_base02 .s:sp_yellow
execute 'highlight! DiffDelete'   .s:fmt_none .s:fg_red    .s:bg_base02
execute 'highlight! DiffText'     .s:fmt_none .s:fg_blue   .s:bg_base02 .s:sp_blue

execute 'highlight! SignColumn'   .s:fmt_none .s:fg_base0  .s:bg_none
execute 'highlight! Conceal'      .s:fmt_none .s:fg_blue   .s:bg_none
execute 'highlight! SpellBad'     .s:fmt_curl .s:fg_none   .s:bg_none   .s:sp_red
execute 'highlight! SpellCap'     .s:fmt_curl .s:fg_none   .s:bg_none   .s:sp_violet
execute 'highlight! SpellRare'    .s:fmt_curl .s:fg_none   .s:bg_none   .s:sp_cyan
execute 'highlight! SpellLocal'   .s:fmt_curl .s:fg_none   .s:bg_none   .s:sp_yellow
"execute 'highlight! Pmenu'        .s:fmt_none .s:fg_base0  .s:bg_base02 .s:fmt_revb
execute 'highlight! Pmenu'        .s:fmt_none .s:fg_base0  .s:bg_base02
execute 'highlight! PmenuSel'     .s:fmt_none .s:fg_base01 .s:bg_base2  .s:fmt_revb
"execute 'highlight! PmenuSbar'    .s:fmt_none .s:fg_base2  .s:bg_base0  .s:fmt_revb
execute 'highlight! PmenuSbar'    .s:fmt_none .s:fg_base2  .s:bg_none   .s:fmt_revb
"execute 'highlight! PmenuThumb'   .s:fmt_none .s:fg_base0  .s:bg_base03 .s:fmt_revb
execute 'highlight! PmenuThumb'   .s:fmt_none .s:fg_base0  .s:bg_none   .s:fmt_revb
execute 'highlight! CursorColumn' .s:fmt_none .s:fg_none   .s:bg_base02
execute 'highlight! CursorLine'   .s:fmt_none .s:fg_none   .s:bg_base02 .s:sp_base1
execute 'highlight! CursorLineNr' .s:fmt_none .s:fg_none   .s:bg_base02 .s:sp_base1
execute 'highlight! ColorColumn'  .s:fmt_none .s:fg_none   .s:bg_base02
execute 'highlight! Cursor'       .s:fmt_none .s:fg_base03 .s:bg_base0
highlight! link lCursor Cursor
execute 'highlight! MatchParen'   .s:fmt_none .s:fg_red    .s:bg_base01

" be nice for this float border to be cyan if active
execute 'highlight! FloatBorder'  .s:fmt_none .s:fg_base00  .s:bg_none

" vim syntax highlighting
" -----------------------
"execute 'highlight! vimLineComment' . s:fg_base01 .s:bg_none   .s:fmt_none
"highlight! link vimComment Comment
"highlight! link vimLineComment Comment
highlight! link vimVar Identifier
highlight! link vimFunc Function
highlight! link vimUserFunc Function
highlight! link helpSpecial Special
highlight! link vimSet Normal
highlight! link vimSetEqual Normal
execute 'highlight! vimCommentString'  .s:fmt_none .s:fg_violet .s:bg_none
execute 'highlight! vimCommand'        .s:fmt_none .s:fg_yellow .s:bg_none
execute 'highlight! vimCmdSep'         .s:fmt_none .s:fg_blue   .s:bg_none
execute 'highlight! helpExample'       .s:fmt_none .s:fg_base1  .s:bg_none
execute 'highlight! helpOption'        .s:fmt_none .s:fg_cyan   .s:bg_none
execute 'highlight! helpNote'          .s:fmt_none .s:fg_magenta.s:bg_none
execute 'highlight! helpVim'           .s:fmt_none .s:fg_magenta.s:bg_none
execute 'highlight! helpHyperTextJump' .s:fmt_undr .s:fg_blue   .s:bg_none
execute 'highlight! helpHyperTextEntry'.s:fmt_none .s:fg_green  .s:bg_none
execute 'highlight! vimIsCommand'      .s:fmt_none .s:fg_base00 .s:bg_none
execute 'highlight! vimSynMtchOpt'     .s:fmt_none .s:fg_yellow .s:bg_none
execute 'highlight! vimSynType'        .s:fmt_none .s:fg_cyan   .s:bg_none
execute 'highlight! vimHiLink'         .s:fmt_none .s:fg_blue   .s:bg_none
execute 'highlight! vimHiGroup'        .s:fmt_none .s:fg_blue   .s:bg_none
execute 'highlight! vimGroup'          .s:fmt_undr .s:fg_blue   .s:bg_none

" diff highlighting
" -----------------
highlight! link diffAdded Statement
highlight! link diffLine Identifier

" git & gitcommit highlighting
" ----------------------------
"execute 'highlight! gitDateHeader'
"execute 'highlight! gitIdentityHeader'
"execute 'highlight! gitIdentityKeyword'
"execute 'highlight! gitNotesHeader'
"execute 'highlight! gitReflogHeader'
"execute 'highlight! gitKeyword'
"execute 'highlight! gitIdentity'
"execute 'highlight! gitEmailDelimiter'
"execute 'highlight! gitEmail'
"execute 'highlight! gitDate'
"execute 'highlight! gitMode'
"execute 'highlight! gitHashAbbrev'
"execute 'highlight! gitHash'
"execute 'highlight! gitReflogMiddle'
"execute 'highlight! gitReference'
"execute 'highlight! gitStage'
"execute 'highlight! gitType'
"execute 'highlight! gitDiffAdded'
"execute 'highlight! gitDiffRemoved'
"gitcommit
"execute 'highlight! gitcommitSummary'
execute 'highlight! gitcommitComment'      .s:fmt_none .s:fg_base01    .s:bg_none
highlight! link gitcommitUntracked gitcommitComment
highlight! link gitcommitDiscarded gitcommitComment
highlight! link gitcommitSelected  gitcommitComment
execute 'highlight! gitcommitUnmerged'     .s:fmt_none .s:fg_green     .s:bg_none
execute 'highlight! gitcommitOnBranch'     .s:fmt_none .s:fg_base01    .s:bg_none
execute 'highlight! gitcommitBranch'       .s:fmt_none .s:fg_magenta   .s:bg_none
highlight! link gitcommitNoBranch gitcommitBranch
execute 'highlight! gitcommitDiscardedType'.s:fmt_none .s:fg_red       .s:bg_none
execute 'highlight! gitcommitSelectedType' .s:fmt_none .s:fg_green     .s:bg_none
"execute 'highlight! gitcommitUnmergedType'
"execute 'highlight! gitcommitType'
"execute 'highlight! gitcommitNoChanges'
"execute 'highlight! gitcommitHeader'
execute 'highlight! gitcommitHeader'       .s:fmt_none .s:fg_base01    .s:bg_none
execute 'highlight! gitcommitUntrackedFile'.s:fmt_none .s:fg_cyan      .s:bg_none
execute 'highlight! gitcommitDiscardedFile'.s:fmt_none .s:fg_red       .s:bg_none
execute 'highlight! gitcommitSelectedFile' .s:fmt_none .s:fg_green     .s:bg_none
execute 'highlight! gitcommitUnmergedFile' .s:fmt_none .s:fg_yellow    .s:bg_none
execute 'highlight! gitcommitFile'         .s:fmt_none .s:fg_base0     .s:bg_none
highlight! link gitcommitDiscardedArrow gitcommitDiscardedFile
highlight! link gitcommitSelectedArrow  gitcommitSelectedFile
highlight! link gitcommitUnmergedArrow  gitcommitUnmergedFile
"execute 'highlight! gitcommitArrow'
"execute 'highlight! gitcommitOverflow'
"execute 'highlight! gitcommitBlank'

" html highlighting
" -----------------
execute 'highlight! htmlTag'           .s:fmt_none .s:fg_base01 .s:bg_none
execute 'highlight! htmlEndTag'        .s:fmt_none .s:fg_base01 .s:bg_none
execute 'highlight! htmlTagN'          .s:fmt_none .s:fg_base1  .s:bg_none
execute 'highlight! htmlTagName'       .s:fmt_none .s:fg_blue   .s:bg_none
execute 'highlight! htmlSpecialTagName'.s:fmt_none .s:fg_blue   .s:bg_none
execute 'highlight! htmlArg'           .s:fmt_none .s:fg_base00 .s:bg_none
execute 'highlight! javaScript'        .s:fmt_none .s:fg_yellow .s:bg_none

" perl highlighting
" -----------------
execute 'highlight! perlHereDoc'           .s:fg_base1  .s:bg_back .s:fmt_none
execute 'highlight! perlVarPlain'          .s:fg_yellow .s:bg_back .s:fmt_none
execute 'highlight! perlStatementFileDesc' .s:fg_cyan   .s:bg_back .s:fmt_none

" tex highlighting
" ----------------
execute 'highlight! texStatement'   .s:fg_cyan   .s:bg_back .s:fmt_none
execute 'highlight! texMathZoneX'   .s:fg_yellow .s:bg_back .s:fmt_none
execute 'highlight! texMathMatcher' .s:fg_yellow .s:bg_back .s:fmt_none
execute 'highlight! texMathMatcher' .s:fg_yellow .s:bg_back .s:fmt_none
execute 'highlight! texRefLabel'    .s:fg_yellow .s:bg_back .s:fmt_none

" ruby highlighting
" -----------------
execute 'highlight! rubyDefine'     .s:fg_base1  .s:bg_back .s:fmt_none
"rubyInclude
"rubySharpBang
"rubyAccess
"rubyPredefinedVariable
"rubyBoolean
"rubyClassVariable
"rubyBeginEnd
"rubyRepeatModifier
"highlight! link rubyArrayDelimiter    Special  " [ , , ]
"rubyCurlyBlock  { , , }

"highlight! link rubyClass             Keyword
"highlight! link rubyModule            Keyword
"highlight! link rubyKeyword           Keyword
"highlight! link rubyOperator          Operator
"highlight! link rubyIdentifier        Identifier
"highlight! link rubyInstanceVariable  Identifier
"highlight! link rubyGlobalVariable    Identifier
"highlight! link rubyClassVariable     Identifier
"highlight! link rubyConstant          Type

" haskell syntax highlighting
" ---------------------------
"
" Treat True and False specially, see the plugin referenced above
let hs_highlight_boolean=1
" highlight delims, see the plugin referenced above
let hs_highlight_delimiters=1

execute 'highlight! cPreCondit' .s:fg_orange.s:bg_none .s:fmt_none

execute 'highlight! VarId'    .s:fg_blue   .s:bg_none .s:fmt_none
execute 'highlight! ConId'    .s:fg_yellow .s:bg_none .s:fmt_none
execute 'highlight! hsImport' .s:fg_magenta.s:bg_none .s:fmt_none
execute 'highlight! hsString' .s:fg_base00 .s:bg_none .s:fmt_none

execute 'highlight! hsStructure'        . s:fg_cyan   .s:bg_none .s:fmt_none
execute 'highlight! hs_hlFunctionName'  . s:fg_blue   .s:bg_none
execute 'highlight! hsStatement'        . s:fg_cyan   .s:bg_none .s:fmt_none
execute 'highlight! hsImportLabel'      . s:fg_cyan   .s:bg_none .s:fmt_none
execute 'highlight! hs_OpFunctionName'  . s:fg_yellow .s:bg_none .s:fmt_none
execute 'highlight! hs_DeclareFunction' . s:fg_orange .s:bg_none .s:fmt_none
execute 'highlight! hsVarSym'           . s:fg_cyan   .s:bg_none .s:fmt_none
execute 'highlight! hsType'             . s:fg_yellow .s:bg_none .s:fmt_none
execute 'highlight! hsTypedef'          . s:fg_cyan   .s:bg_none .s:fmt_none
execute 'highlight! hsModuleName'       . s:fg_green  .s:bg_none .s:fmt_undr
execute 'highlight! hsModuleStartLabel' . s:fg_magenta.s:bg_none .s:fmt_none
highlight! link hsImportParams      Delimiter
highlight! link hsDelimTypeExport   Delimiter
highlight! link hsModuleStartLabel  hsStructure
highlight! link hsModuleWhereLabel  hsModuleStartLabel

" following is for the haskell-conceal plugin
" the first two items don't have an impact, but better safe
execute 'highlight! hsNiceOperator'     .s:fg_cyan .s:bg_none .s:fmt_none
execute 'highlight! hsniceoperator'     .s:fg_cyan .s:bg_none .s:fmt_none

" pandoc markdown syntax highlighting
" -----------------------------------
execute 'highlight! pandocTitleBlock'        .s:fg_blue   .s:bg_none .s:fmt_none
execute 'highlight! pandocTitleBlockTitle'   .s:fg_blue   .s:bg_none .s:fmt_none
execute 'highlight! pandocTitleComment'      .s:fg_blue   .s:bg_none .s:fmt_none
execute 'highlight! pandocComment'           .s:fg_base01 .s:bg_none .s:fmt_none
execute 'highlight! pandocVerbatimBlock'     .s:fg_yellow .s:bg_none .s:fmt_none
highlight! link pandocVerbatimBlockDeep pandocVerbatimBlock
highlight! link pandocCodeBlock         pandocVerbatimBlock
highlight! link pandocCodeBlockDelim    pandocVerbatimBlock
execute 'highlight! pandocBlockQuote'        .s:fg_blue   .s:bg_none .s:fmt_none
execute 'highlight! pandocBlockQuoteLeader1' .s:fg_blue   .s:bg_none .s:fmt_none
execute 'highlight! pandocBlockQuoteLeader2' .s:fg_cyan   .s:bg_none .s:fmt_none
execute 'highlight! pandocBlockQuoteLeader3' .s:fg_yellow .s:bg_none .s:fmt_none
execute 'highlight! pandocBlockQuoteLeader4' .s:fg_red    .s:bg_none .s:fmt_none
execute 'highlight! pandocBlockQuoteLeader5' .s:fg_base0  .s:bg_none .s:fmt_none
execute 'highlight! pandocBlockQuoteLeader6' .s:fg_base01 .s:bg_none .s:fmt_none
execute 'highlight! pandocListMarker'        .s:fg_magenta.s:bg_none .s:fmt_none
execute 'highlight! pandocListReference'     .s:fg_magenta.s:bg_none .s:fmt_undr

" Definitions
" -----------
let s:fg_pdef = s:fg_violet
execute 'highlight! pandocDefinitionBlock'              .s:fg_pdef  .s:bg_none  .s:fmt_none
execute 'highlight! pandocDefinitionTerm'               .s:fg_pdef  .s:bg_none  .s:fmt_stnd
execute 'highlight! pandocDefinitionIndctr'             .s:fg_pdef  .s:bg_none  .s:fmt_none
execute 'highlight! pandocEmphasisDefinition'           .s:fg_pdef  .s:bg_none  .s:fmt_none
execute 'highlight! pandocEmphasisNestedDefinition'     .s:fg_pdef  .s:bg_none  .s:fmt_none
execute 'highlight! pandocStrongEmphasisDefinition'     .s:fg_pdef  .s:bg_none  .s:fmt_none
execute 'highlight! pandocStrongEmphasisNestedDefinition'   .s:fg_pdef.s:bg_none.s:fmt_none
execute 'highlight! pandocStrongEmphasisEmphasisDefinition' .s:fg_pdef.s:bg_none.s:fmt_none
execute 'highlight! pandocStrikeoutDefinition'          .s:fg_pdef  .s:bg_none  .s:fmt_revr
execute 'highlight! pandocVerbatimInlineDefinition'     .s:fg_pdef  .s:bg_none  .s:fmt_none
execute 'highlight! pandocSuperscriptDefinition'        .s:fg_pdef  .s:bg_none  .s:fmt_none
execute 'highlight! pandocSubscriptDefinition'          .s:fg_pdef  .s:bg_none  .s:fmt_none

" Tables
" ------
let s:fg_ptable = s:fg_blue
execute 'highlight! pandocTable'                        .s:fg_ptable.s:bg_none  .s:fmt_none
execute 'highlight! pandocTableStructure'               .s:fg_ptable.s:bg_none  .s:fmt_none
highlight! link pandocTableStructureTop pandocTableStructre
highlight! link pandocTableStructureEnd pandocTableStructre
execute 'highlight! pandocTableZebraLight'              .s:fg_ptable.s:bg_base03.s:fmt_none
execute 'highlight! pandocTableZebraDark'               .s:fg_ptable.s:bg_base02.s:fmt_none
execute 'highlight! pandocEmphasisTable'                .s:fg_ptable.s:bg_none  .s:fmt_none
execute 'highlight! pandocEmphasisNestedTable'          .s:fg_ptable.s:bg_none  .s:fmt_none
execute 'highlight! pandocStrongEmphasisTable'          .s:fg_ptable.s:bg_none  .s:fmt_none
execute 'highlight! pandocStrongEmphasisNestedTable'    .s:fg_ptable.s:bg_none  .s:fmt_none
execute 'highlight! pandocStrongEmphasisEmphasisTable'  .s:fg_ptable.s:bg_none  .s:fmt_none
execute 'highlight! pandocStrikeoutTable'               .s:fg_ptable.s:bg_none  .s:fmt_revr
execute 'highlight! pandocVerbatimInlineTable'          .s:fg_ptable.s:bg_none  .s:fmt_none
execute 'highlight! pandocSuperscriptTable'             .s:fg_ptable.s:bg_none  .s:fmt_none
execute 'highlight! pandocSubscriptTable'               .s:fg_ptable.s:bg_none  .s:fmt_none

" Headings
" --------
let s:fg_phead = s:fg_orange
execute 'highlight! pandocHeading'                      .s:fg_phead .s:bg_none.s:fmt_none
execute 'highlight! pandocHeadingMarker'                .s:fg_yellow.s:bg_none.s:fmt_none
execute 'highlight! pandocEmphasisHeading'              .s:fg_phead .s:bg_none.s:fmt_none
execute 'highlight! pandocEmphasisNestedHeading'        .s:fg_phead .s:bg_none.s:fmt_none
execute 'highlight! pandocStrongEmphasisHeading'        .s:fg_phead .s:bg_none.s:fmt_none
execute 'highlight! pandocStrongEmphasisNestedHeading'  .s:fg_phead .s:bg_none.s:fmt_none
execute 'highlight! pandocStrongEmphasisEmphasisHeading'.s:fg_phead .s:bg_none.s:fmt_none
execute 'highlight! pandocStrikeoutHeading'             .s:fg_phead .s:bg_none.s:fmt_revr
execute 'highlight! pandocVerbatimInlineHeading'        .s:fg_phead .s:bg_none.s:fmt_none
execute 'highlight! pandocSuperscriptHeading'           .s:fg_phead .s:bg_none.s:fmt_none
execute 'highlight! pandocSubscriptHeading'             .s:fg_phead .s:bg_none.s:fmt_none

" Links
" -----
execute 'highlight! pandocLinkDelim'        .s:fg_base01 .s:bg_none .s:fmt_none
execute 'highlight! pandocLinkLabel'        .s:fg_blue   .s:bg_none .s:fmt_undr
execute 'highlight! pandocLinkText'         .s:fg_blue   .s:bg_none .s:fmt_undr
execute 'highlight! pandocLinkURL'          .s:fg_base00 .s:bg_none .s:fmt_undr
execute 'highlight! pandocLinkTitle'        .s:fg_base00 .s:bg_none .s:fmt_undr
execute 'highlight! pandocLinkTitleDelim'   .s:fg_base01 .s:bg_none .s:fmt_undr .s:sp_base00
execute 'highlight! pandocLinkDefinition'   .s:fg_cyan   .s:bg_none .s:fmt_undr .s:sp_base00
execute 'highlight! pandocLinkDefinitionID' .s:fg_blue   .s:bg_none .s:fmt_none
execute 'highlight! pandocImageCaption'     .s:fg_violet .s:bg_none .s:fmt_undr
execute 'highlight! pandocFootnoteLink'     .s:fg_green  .s:bg_none .s:fmt_undr
execute 'highlight! pandocFootnoteDefLink'  .s:fg_green  .s:bg_none .s:fmt_none
execute 'highlight! pandocFootnoteInline'   .s:fg_green  .s:bg_none .s:fmt_undr
execute 'highlight! pandocFootnote'         .s:fg_green  .s:bg_none .s:fmt_none
execute 'highlight! pandocCitationDelim'    .s:fg_magenta.s:bg_none .s:fmt_none
execute 'highlight! pandocCitation'         .s:fg_magenta.s:bg_none .s:fmt_none
execute 'highlight! pandocCitationID'       .s:fg_magenta.s:bg_none .s:fmt_undr
execute 'highlight! pandocCitationRef'      .s:fg_magenta.s:bg_none .s:fmt_none

" Main Styles
" -----------
execute 'highlight! pandocStyleDelim'             .s:fg_base01 .s:bg_none .s:fmt_none
execute 'highlight! pandocEmphasis'               .s:fg_base0  .s:bg_none .s:fmt_none
execute 'highlight! pandocEmphasisNested'         .s:fg_base0  .s:bg_none .s:fmt_none
execute 'highlight! pandocStrongEmphasis'         .s:fg_base0  .s:bg_none .s:fmt_none
execute 'highlight! pandocStrongEmphasisNested'   .s:fg_base0  .s:bg_none .s:fmt_none
execute 'highlight! pandocStrongEmphasisEmphasis' .s:fg_base0  .s:bg_none .s:fmt_none
execute 'highlight! pandocStrikeout'              .s:fg_base01 .s:bg_none .s:fmt_revr
execute 'highlight! pandocVerbatimInline'         .s:fg_yellow .s:bg_none .s:fmt_none
execute 'highlight! pandocSuperscript'            .s:fg_violet .s:bg_none .s:fmt_none
execute 'highlight! pandocSubscript'              .s:fg_violet .s:bg_none .s:fmt_none

execute 'highlight! pandocRule'                   .s:fg_blue   .s:bg_none .s:fmt_none
execute 'highlight! pandocRuleLine'               .s:fg_blue   .s:bg_none .s:fmt_none
execute 'highlight! pandocEscapePair'             .s:fg_red    .s:bg_none .s:fmt_none
execute 'highlight! pandocCitationRef'            .s:fg_magenta.s:bg_none .s:fmt_none
execute 'highlight! pandocNonBreakingSpace'       .s:fg_red    .s:bg_none .s:fmt_revr
highlight! link pandocEscapedCharacter pandocEscapePair
highlight! link pandocLineBreak        pandocEscapePair

" Embedded Code
" -------------
execute 'highlight! pandocMetadataDelim' .s:fg_base01 .s:bg_none .s:fmt_none
execute 'highlight! pandocMetadata'      .s:fg_blue   .s:bg_none .s:fmt_none
execute 'highlight! pandocMetadataKey'   .s:fg_blue   .s:bg_none .s:fmt_none
execute 'highlight! pandocMetadata'      .s:fg_blue   .s:bg_none .s:fmt_none
highlight! link pandocMetadataTitle pandocMetadata

" neomake highlighting
" --------------------
execute 'highlight! NeomakeErrorSign'       .s:fg_orange .s:bg_none .s:fmt_none
execute 'highlight! NeomakeWarningSign'     .s:fg_yellow .s:bg_none .s:fmt_none
execute 'highlight! NeomakeMessageSign'     .s:fg_cyan   .s:bg_none .s:fmt_none
execute 'highlight! NeomakeNeomakeInfoSign' .s:fg_green  .s:bg_none .s:fmt_none

" gitgutter highlighting
" ----------------------
execute 'highlight! GitGutterAdd'          .s:fg_green  .s:bg_none .s:fmt_none
execute 'highlight! GitGutterChange'       .s:fg_yellow .s:bg_none .s:fmt_none
execute 'highlight! GitGutterDelete'       .s:fg_red    .s:bg_none .s:fmt_none
execute 'highlight! GitGutterChangeDelete' .s:fg_red    .s:bg_none .s:fmt_none

" signify highlighting
" --------------------
execute 'highlight! SignifySignAdd'          .s:fg_green  .s:bg_none .s:fmt_none
execute 'highlight! SignifySignChange'       .s:fg_yellow .s:bg_none .s:fmt_none
execute 'highlight! SignifySignDelete'       .s:fg_red    .s:bg_none .s:fmt_none
execute 'highlight! SignifySignChangeDelete' .s:fg_red    .s:bg_none .s:fmt_none

" ALE highlighting
" ----------------
execute 'highlight! ALEErrorSign'   .s:fg_orange .s:bg_none .s:fmt_none
execute 'highlight! ALEWarningSign' .s:fg_yellow .s:bg_none .s:fmt_none

" NeoVim terminal buffer colours
" ------------------------------
let g:terminal_color_0 = s:gui_base03
let g:terminal_color_1 = s:gui_red
let g:terminal_color_2 = s:gui_green
let g:terminal_color_3 = s:gui_yellow
let g:terminal_color_4 = s:gui_blue
let g:terminal_color_5 = s:gui_magenta
let g:terminal_color_6 = s:gui_cyan
let g:terminal_color_7 = s:gui_base2

let g:terminal_color_8 = s:gui_base02
let g:terminal_color_9 = s:gui_orange
let g:terminal_color_10 = s:gui_base01
let g:terminal_color_11 = s:gui_base00
let g:terminal_color_12 = s:gui_base0
let g:terminal_color_13 = s:gui_violet
let g:terminal_color_14 = s:gui_base1
let g:terminal_color_15 = s:gui_base3

" Utility autocommand
" -------------------
autocmd GUIEnter * if (has('gui_running')) | execute "colorscheme " . g:colors_name | endif

" Tabline
" -------
highlight! TabLine         ctermfg=243 ctermbg=236 guifg=#767676 guibg=#303030 cterm=NONE gui=NONE
highlight! TablineAlt      ctermfg=252 ctermbg=238 guifg=#D0D0D0 guibg=#444444 cterm=NONE,bold gui=NONE,bold
highlight! TabLineAltShade ctermfg=238 ctermbg=236 guifg=#444444 guibg=#303030 cterm=NONE gui=NONE
highlight! TablineFill     ctermfg=4   ctermbg=8   guifg=#268bd2 guibg=#002b36 cterm=NONE gui=NONE
highlight! link TabLineSel Normal
highlight! TabLineSep      ctermfg=0   ctermbg=236 guifg=#2C2C2C guibg=#303030 cterm=NONE gui=NONE
highlight! TabLineSepSel   ctermfg=4   ctermbg=8   guifg=#268bd2 guibg=#002b36 cterm=NONE gui=NONE

" TreeSitter
" ----------
highlight! link TSBoolean Constant
highlight! link TSCharacter Constant
highlight! link TSComment Comment
highlight! link TSConditional Conditional
highlight! link TSConstant Constant
highlight! link TSConstBuiltin Constant
highlight! link TSConstMacro Constant
highlight! link TSError Error
highlight! link TSException Exception
highlight! link TSField Identifier
"highlight! link TSFloat Float
highlight! link TSFloat Constant
highlight! link TSFunction Function
highlight! link TSFuncBuiltin Function
highlight! link TSFuncMacro Function
highlight! link TSInclude Include
highlight! link TSKeyword Keyword
"highlight! link TSLabel Label
highlight! link TSLabel Statement
highlight! link TSMethod Function
highlight! link TSNamespace Identifier
highlight! link TSNumber Constant
highlight! link TSOperator Operator
highlight! link TSParameterReference Identifier
highlight! link TSProperty TSField
highlight! link TSPunctDelimiter Delimiter
highlight! link TSPunctBracket Delimiter
highlight! link TSPunctSpecial Special
highlight! link TSRepeat Repeat
highlight! link TSString Constant
highlight! link TSStringRegex Constant
highlight! link TSStringEscape Constant
execute 'highlight! TSSStrong' .s:fmt_bold .s:fg_base1 .s:bg_base03
highlight! link TSConstructor Function
highlight! link TSKeywordFunction Identifier
highlight! link TSLiteral Normal
highlight! link TSParameter Identifier
"execute 'highlight! TSVariable' .s:fmt_none .s:fg_base1 .s:bg_none
highlight! link TSVariable Normal
highlight! link TSVariableBuiltin Identifier
highlight! link TSTag Special
highlight! link TSTagDelimiter Delimiter
highlight! link TSTitle Title
highlight! link TSType Type
highlight! link TSTypeBuiltin Type

if has('nvim-0.8')
	" Misc
	highlight! link @none NONE
	highlight! link @comment Comment
	highlight! link @error Error
	highlight! link @preproc PreProc
	highlight! link @define Define
	highlight! link @operator Operator

	" Punctuation
	highlight! link @punctuation.delimiter Statement
	highlight! link @punctuation.bracket Delimiter
	highlight! link @punctuation.special Delimiter

	" Literals
	highlight! link @string String
	highlight! link @string.regex String
	highlight! link @string.escape Special
	highlight! link @string.special Special

	highlight! link @character Character
	highlight! link @character.special Special

	highlight! link @boolean Boolean
	highlight! link @number Number
	highlight! link @float Float

	" Functions
	highlight! link @function Function
	highlight! link @function.call Function
	highlight! link @function.builtin Function
	highlight! link @function.macro Macro

	highlight! link @method Function
	highlight! link @method.call Function

	highlight! link @constructor Special
	highlight! link @parameter Normal

	" Keywords
	highlight! link @keyword Keyword
	highlight! link @keyword.function Keyword
	highlight! link @keyword.operator Keyword
	highlight! link @keyword.return Keyword

	highlight! link @conditional Conditional
	highlight! link @repeat Repeat
	highlight! link @debug Debug
	highlight! link @label Label
	highlight! link @include Include
	highlight! link @exception Exception

	" Types
	highlight! link @type Type
	highlight! link @type.builtin Type
	highlight! link @type.qualifier Type
	highlight! link @type.definition Typedef

	highlight! link @storageclass StorageClass
	highlight! link @attribute Identifier
	highlight! link @field Identifier
	highlight! link @property Identifier

	" Identifiers
	"execute 'highlight! @variable' .s:fmt_none .s:fg_base1 .s:bg_none
	execute 'highlight! @variable' .s:fmt_none .s:fg_base0 .s:bg_none
	highlight! link @variable.builtin Special

	highlight! link @constant Constant
	highlight! link @constant.builtin Type
	highlight! link @constant.macro Define

	highlight! link @namespace Identifier
	highlight! link @symbol Identifier

	" Text
	highlight! link @text Normal
	"execute 'highlight! @strong' .s:fmt_bold .s:fg_base1 .s:bg_base03
	"execute 'highlight! @text.emphasis' .s:fmt_bold .s:fg_base1 .s:bg_base03
	execute 'highlight! @strong' .s:fmt_bold .s:fg_base1 .s:bg_none
	execute 'highlight! @text.emphasis' .s:fmt_bold .s:fg_base1 .s:bg_none
	highlight! link @text.underline Underlined
	highlight! link @text.strike Strikethrough
	highlight! link @text.title Title
	highlight! link @text.literal String
	highlight! link @text.uri Underlined
	highlight! link @text.math Special
	highlight! link @text.environment Macro
	highlight! link @text.environment.name Type
	highlight! link @text.reference Constant

	highlight! link @text.todo Todo
	highlight! link @text.note Comment
	highlight! link @text.warning WarningMsg
	execute 'highlight! @text.danger' .s:fmt_bold .s:fg_red .s:bg_none

	" Tags
	"highlight! link @tag Tag
	"highlight! link @tag.attribute Identifier
	"highlight! link @tag.delimiter Delimiter
	execute 'highlight! @tag' .s:fmt_none .s:fg_green .s:bg_none
	execute 'highlight! @tag.attribute' .s:fmt_none .s:fg_blue .s:bg_none
	execute 'highlight! @tag.delimiter' .s:fmt_none .s:fg_red .s:bg_none
endif

if has('nvim-0.9.0')
	highlight! link @lsp.type.type Type
	highlight! link @lsp.type.class Type
	highlight! link @lsp.type.enum Type
	highlight! link @lsp.type.interface Type
	highlight! link @lsp.type.struct Type
	highlight! link @lsp.type.typeParameter Type
	highlight! link @lsp.type.parameter Normal
	highlight! link @lsp.type.variable TSVariable
	highlight! link @lsp.type.property TSProperty
	highlight! link @lsp.type.enumMember TSProperty
	highlight! link @lsp.type.events Label
	highlight! link @lsp.type.function Function
	highlight! link @lsp.type.method TSMethod
	highlight! link @lsp.type.keyword Keyword
	highlight! link @lsp.type.modifier Operator
	highlight! link @lsp.type.comment Comment
	highlight! link @lsp.type.string String
	highlight! link @lsp.type.number Number
	highlight! link @lsp.type.regexp TSStringRegex
	highlight! link @lsp.type.operator Operator
endif

" LSP and Diagnostic
" ------------------
execute 'highlight! DiagnosticError'          .s:fmt_none .s:fg_red    .s:bg_none .s:sp_red
execute 'highlight! DiagnosticWarn'           .s:fmt_none .s:fg_yellow .s:bg_none .s:sp_yellow
execute 'highlight! DiagnosticInfo'           .s:fmt_none .s:fg_cyan   .s:bg_none .s:sp_cyan
execute 'highlight! DiagnosticHint'           .s:fmt_none .s:fg_green  .s:bg_none .s:sp_green
execute 'highlight! DiagnosticUnderlineError' .s:fmt_undr .s:fg_none   .s:bg_none .s:sp_red
execute 'highlight! DiagnosticUnderlineWarn'  .s:fmt_undr .s:fg_none   .s:bg_none .s:sp_yellow
execute 'highlight! DiagnosticUnderlineInfo'  .s:fmt_undr .s:fg_none   .s:bg_none .s:sp_cyan
execute 'highlight! DiagnosticUnderlineHint'  .s:fmt_undr .s:fg_none   .s:bg_none .s:sp_green

execute 'highlight! LspReferenceRead'  .s:fmt_undr .s:fg_none .s:bg_none
highlight! link LspReferenceText LspReferenceRead
execute 'highlight! LspReferenceWrite' .s:fmt_bolu .s:fg_none .s:bg_none

" Lspsaga syntax support
" ----------------------
highlight! default link HoverNormal Normal
highlight! default link HoverBorder FloatBorder

execute 'highlight! ProviderTruncateLine' .s:fmt_none .s:fg_base02 .s:bg_none

highlight! link TargetWord Title

highlight! link GitSignsAdd DiffAdd
highlight! link GitSignsChange DiffChange
highlight! link GitSignsDelete DiffDelete

highlight! link VGitSignAdd DiffAdd
highlight! link VGitSignChange DiffChange
highlight! link VGitSignRemove DiffDelete

" nvim-cmp syntax support
" -----------------------
execute 'highlight! CmpDocumentation'       .s:fmt_none .s:fg_base2 .s:bg_base02
execute 'highlight! CmpDocumentationBorder' .s:fmt_none .s:fg_base2 .s:bg_base02

execute 'highlight! CmpItemAbbr'           .s:fmt_none .s:fg_base1 .s:bg_none
execute 'highlight! CmpItemAbbrDeprecated' .s:fmt_none .s:fg_base0 .s:bg_none
execute 'highlight! CmpItemAbbrMatch'      .s:fmt_none .s:fg_base2 .s:bg_none
execute 'highlight! CmpItemAbbrMatchFuzzy' .s:fmt_none .s:fg_base2 .s:bg_none

execute 'highlight! CmpItemKindDefault'	      .s:fmt_none .s:fg_base1  .s:bg_none
execute 'highlight! CmpItemMenu'              .s:fmt_none .s:fg_base1  .s:bg_none
execute 'highlight! CmpItemKindKeyword'       .s:fmt_none .s:fg_yellow .s:bg_none
execute 'highlight! CmpItemKindVariable'      .s:fmt_none .s:fg_green  .s:bg_none
execute 'highlight! CmpItemKindConstant'      .s:fmt_none .s:fg_base1  .s:bg_none
execute 'highlight! CmpItemKindReference'     .s:fmt_none .s:fg_base1  .s:bg_none
execute 'highlight! CmpItemKindValue'         .s:fmt_none .s:fg_base1  .s:bg_none
execute 'highlight! CmpItemKindFunction'      .s:fmt_none .s:fg_blue   .s:bg_none
execute 'highlight! CmpItemKindMethod'        .s:fmt_none .s:fg_blue   .s:bg_none
execute 'highlight! CmpItemKindConstructor'   .s:fmt_none .s:fg_blue   .s:bg_none
execute 'highlight! CmpItemKindClass'         .s:fmt_none .s:fg_red    .s:bg_none
execute 'highlight! CmpItemKindInterface'     .s:fmt_none .s:fg_base1  .s:bg_none
execute 'highlight! CmpItemKindStruct'        .s:fmt_none .s:fg_base1  .s:bg_none
execute 'highlight! CmpItemKindEvent'         .s:fmt_none .s:fg_base1  .s:bg_none
execute 'highlight! CmpItemKindEnum'          .s:fmt_none .s:fg_base1  .s:bg_none
execute 'highlight! CmpItemKindUnit'          .s:fmt_none .s:fg_base1  .s:bg_none
execute 'highlight! CmpItemKindModule'        .s:fmt_none .s:fg_base1  .s:bg_none
execute 'highlight! CmpItemKindProperty'      .s:fmt_none .s:fg_base1  .s:bg_none
execute 'highlight! CmpItemKindField'         .s:fmt_none .s:fg_base1  .s:bg_none
execute 'highlight! CmpItemKindTypeParameter' .s:fmt_none .s:fg_base1  .s:bg_none
execute 'highlight! CmpItemKindEnumMember'    .s:fmt_none .s:fg_base1  .s:bg_none
execute 'highlight! CmpItemKindOperator'      .s:fmt_none .s:fg_base1  .s:bg_none
execute 'highlight! CmpItemKindSnippet'       .s:fmt_none .s:fg_orange .s:bg_none

" Telescope
" ---------
" float border not quite dark enough, maybe that needs to change?
execute 'highlight! TelescopeMatching'        .s:fmt_none .s:fg_rose  .s:bg_none
execute 'highlight! TelescopeBorder'          .s:fmt_none .s:fg_base00 .s:bg_none
execute 'highlight! TelescopePromptBorder'    .s:fmt_none .s:fg_base00 .s:bg_none
execute 'highlight! TelescopeResultsBorder'   .s:fmt_none .s:fg_base00 .s:bg_none
execute 'highlight! TelescopePreviewBorder'   .s:fmt_none .s:fg_base00 .s:bg_none
highlight! link TelescopePromptPrefix Normal
highlight! link TelescopeSelection CursorLine
execute 'highlight! TelescopeSelectionCaret'  .s:fmt_none .s:fg_dark5 .s:bg_base02
execute 'highlight! TelescopeTitle'           .s:fmt_none .s:fg_white .s:bg_none

" nvim-navic
" ----------
highlight! link NavicIconsFile          Tag
highlight! link NavicIconsModule        Exception
highlight! link NavicIconsNamespace     Include
highlight! link NavicIconsPackage       Label
highlight! link NavicIconsClass         Include
highlight! link NavicIconsMethod        Function
highlight! link NavicIconsProperty      Identifier
highlight! link NavicIconsField         Identifier
highlight! link NavicIconsConstructor   Special
highlight! link NavicIconsEnum          Number
highlight! link NavicIconsInterface     Type
highlight! link NavicIconsFunction      Function
highlight! link NavicIconsVariable      Variable
highlight! link NavicIconsConstant      Constant
highlight! link NavicIconsString        String
highlight! link NavicIconsNumber        Number
highlight! link NavicIconsBoolean       Boolean
highlight! link NavicIconsArray         Type
highlight! link NavicIconsObject        Type
highlight! link NavicIconsKey           Normal
highlight! link NavicIconsNull          Constant
highlight! link NavicIconsEnumMember    Number
highlight! link NavicIconsStruct        Type
highlight! link NavicIconsEvent         Constant
highlight! link NavicIconsOperator      Operator
highlight! link NavicIconsTypeParameter Normal
highlight! link NavicText               Normal
execute 'highlight! NavicSeparator'     .s:fmt_none .s:fg_magenta .s:bg_none

" which-key
" ---------
highlight! link WhichKeyFloat Normal

" Original highlights
" -------------------
execute 'highlight! WinbarLspClientName' .s:fmt_none .s:fg_white .s:bg_none

" License
" -------
" Copyright (c) 2011 Ethan Schoonover
" Copyright (c) 2016 iCyMind
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.

" vim: set ts=2 sw=2 tw=80 noet:
