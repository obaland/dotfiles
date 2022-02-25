"-----------------------------------------------------------------------------
" nvim-treesitter.rc.vim
"-----------------------------------------------------------------------------

lua <<EOF

require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'bash',
    'c',
    'cpp',
    'c_sharp',
    'css',
    'dockerfile',
    'html',
    'javascript',
    'json',
    'lua',
    'make',
    'php',
    'python',
    'ruby',
    'typescript',
    'toml',
    'vim',
    'yaml',
  },

  highlight = {
    enable = true,
    disable = {},
  },
}

EOF

"---------------------------------------------------------------------------
" Custom highlights
"

" Custom Colors
highlight link SolarizedDarkYellow  Type
highlight link SolarizedDarkOrange  PreProc
highlight link SolarizedDarkRed     Special
highlight link SolarizedDarkMagenta helpNote
highlight link SolarizedDarkViolet  Underlined
highlight link SolarizedDarkBlue    Identifier
highlight link SolarizedDarkCyan    Constant 
highlight link SolarizedDarkGreen   Statement

" nvim treesitter colors
highlight! link TSConstructor SolarizedDarkViolet
highlight! link TSFuncBuiltin SolarizedDarkViolet
highlight! link TSPunctBracket SolarizedDarkOrange
highlight! link TSPunctDelimiter SolarizedDarkOrange
highlight! link TSVariableBuiltin SolarizedDarkViolet
