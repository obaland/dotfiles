" Key mappings
"=============================================================================

" File operations
" ---------------

" Switch (window) to the directory of the current opened buffer
nmap <Leader>cd :lcd %:p:h<CR>:pwd<CR>

" nvim-treesitter
" ---------------
if dein#tap('trouble.nvim')
  nnoremap <leader>xx <cmd>TroubleToggle<CR>
  nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<CR>
  nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<CR>
  nnoremap <leader>xq <cmd>TroubleToggle quickfix<CR>
  nnoremap <leader>xl <cmd>TroubleToggle loclist<CR>
  nnoremap gR <cmd>TroubleToggle lsp_reference<CR>
  nnoremap ]x <cmd>lua require('trouble').next({skip_groups = true, jump = true})<CR>
  nnoremap [x <cmd>lua require('trouble').previous({skip_groups = true, jump = true})<CR>
endif

" telescope.nvim
" --------------
if dein#tap('telescope.nvim')
  " General pickers
  nnoremap <leader>r <cmd>Telescope resume initial_mode=normal<CR>
  nnoremap <leader>a <cmd>Telescope autocommands<CR>
  nnoremap <leader>bb <cmd>Telescope buffers<CR>
  nnoremap <leader>hl <cmd>Telescope highlights<CR>
  nnoremap <leader>v <cmd>Telescope registers<CR>
	nnoremap <leader>; <cmd>Telescope command_history<CR>
	nnoremap <leader>/ <cmd>Telescope search_history<CR>

  " Grep
  nnoremap <leader>gg <cmd>lua require('plugins/telescope').grep()<CR>
  nnoremap <leader>gb <cmd>lua require('plugins/telescope').grep_buffer()<CR>
  nnoremap <leader>gw <cmd>lua require('plugins/telescope').grep_string()<CR>

  " Find files
  nnoremap <leader>ff <cmd>lua require('plugins/telescope').find_files()<CR>
  nnoremap <leader>fb <cmd>lua require('plugins/telescope').find_files_buffer()<CR>
  nnoremap <leader>fg <cmd>Telescope git_files<CR>
  nnoremap <leader>fm <cmd>Telescope oldfiles<CR>

  " Key maps
  nnoremap <leader>mm <cmd>lua require('telescope/builtin').keymaps()<CR>
  nnoremap <leader>mn <cmd>lua require('telescope/builtin').keymaps({modes = {'n'}})<CR>
  nnoremap <leader>mx <cmd>lua require('telescope/builtin').keymaps({modes = {'x'}})<CR>
  nnoremap <leader>mo <cmd>lua require('telescope/builtin').keymaps({modes = {'o'}})<CR>
  nnoremap <leader>mi <cmd>lua require('telescope/builtin').keymaps({modes = {'i'}})<CR>

  " LSP related
  nnoremap <leader>dd <cmd>Telescope lsp_definitions<CR>
  nnoremap <leader>di <cmd>Telescope lsp_implementations<CR>
  nnoremap <leader>dr <cmd>Telescope lsp_references<CR>
  nnoremap <leader>da <cmd>Telescope lsp_code_actions<CR>
  xnoremap <leader>da :Telescope lsp_range_code_actions<CR>
endif

" vim-vsnip
" ---------
if dein#tap('vim-vsnip')
  imap <expr><C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
  smap <expr><C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
endif

" emmet-vim
" -------------------
if dein#tap('emmet-vim')
  autocmd user_events FileType html,css,vue,javascript,javascriptreact,svelte |
        \ EmmetInstall |
        \ imap <silent><buffer> <C-y> <Plug>(emmet-expand-abbr)
endif

" vim-sandwich
" ------------
if dein#tap('vim-sandwich')
  nmap <silent>sa <Plug>(sandwich-add)
  xmap <silent>sa <Plug>(sandwich-add)
  omap <silent>sa <Plug>(sandwich-add)

  nmap <silent>sd <Plug>(sandwich-delete)
  xmap <silent>sd <Plug>(sandwich-delete)
  nmap <silent>sdb <Plug>(sandwich-delete-auto)

  nmap <silent>sr <Plug>(sandwich-replace)
  xmap <silent>sr <Plug>(sandwich-replace)
  nmap <silent>srb <Plug>(sandwich-replace-auto)

  omap <silent>ib <Plug>(textobj-sandwich-auto-i)
  xmap <silent>ib <Plug>(textobj-sandwich-auto-i)
  omap <silent>ab <Plug>(textobj-sandwich-auto-a)
  xmap <silent>ab <Plug>(textobj-sandwich-auto-a)

  omap <silent>is <Plug>(textobj-sandwich-query-i)
  xmap <silent>is <Plug>(textobj-sandwich-query-i)
  omap <silent>as <Plug>(textobj-sandwich-query-a)
  xmap <silent>as <Plug>(textobj-sandwich-query-a)
endif

" sideways.vim
" ------------
if dein#tap('sideways.vim')
  nnoremap <silent><leader>< <cmd>SidewaysLeft<CR>
  nnoremap <silent><leader>> <cmd>SidewaysRight<CR>
  nnoremap <silent><leader>[ <cmd>SidewaysJumpLeft<CR>
  nnoremap <silent><leader>] <cmd>SidewaysJumpRight<CR>
  omap <silent>aa <Plug>SidewaysArgumentTextobjA
  xmap <silent>aa <Plug>SidewaysArgumentTextobjA
  omap <silent>ai <Plug>SidewaysArgumentTextobjI
  xmap <silent>ai <Plug>SidewaysArgumentTextobjI
endif

" splitjoin.vim
" -------------
if dein#tap('splitjoin.vim')
	nmap sj <cmd>SplitjoinJoin<CR>
	nmap ss <cmd>SplitjoinSplit<CR>
endif

" linediff.vim
" ------------
if dein#tap('linediff.vim')
  xnoremap <leader>ldf :Linediff<CR>
  xnoremap <leader>lda :LinediffAdd<CR>
  nnoremap <leader>lds <cmd>LinediffShow<CR>
  nnoremap <leader>ldr <cmd>LinediffReset<CR>
endif

" aerial.nvim
" ------------
if dein#tap('aerial.nvim')
  nnoremap <silent><leader>o <cmd>AerialToggle<CR>
  nnoremap <silent><leader>n <cmd>AerialNavToggle<CR>
  if dein#tap('telescope.nvim')
    nnoremap <silent><leader>O <cmd>Telescope aerial<CR>
  endif
endif

" dsf.vim
" -------
if dein#tap('dsf.vim')
  nmap <leader>dsf <Plug>DsfDelete
  nmap <leader>csf <Plug>DsfChange
endif

" which-key.nvim
" --------------
if dein#tap('which-key.nvim')
  nnoremap <leader>ww <cmd>WhichKey<CR>
  nnoremap <leader>wn <cmd>WhichKey '' n<CR>
  nnoremap <leader>wi <cmd>WhichKey '' i<CR>
  nnoremap <leader>wv <cmd>WhichKey '' v<CR>
endif

" vfiler.vim
" ----------
if dein#tap('vfiler.vim')
  " Explorer view by vfiler.vim.
  noremap <silent><leader>e <cmd>lua
        \ require('plugins/vfiler').start_exprolorer()<CR>

  " Floating view by vfiler.vim.
  noremap <silent><leader>E <cmd>VFiler -layout=floating<CR>
endif

" nvim-treesitter
" ---------------
if dein#tap('nvim-treesitter')
  noremap <silent><leader>tsc <cmd>TSHighlightCapturesUnderCursor<CR>
endif

" Terminal emulator
" -----------------
if has('nvim')
  tnoremap <silent> <ESC> <C-\><C-n>
endif

" vim: foldmethod=marker
