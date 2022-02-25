"-----------------------------------------------------------------------------
" nvim-cmp.rc.vim
"-----------------------------------------------------------------------------
lua <<EOF

local function feedkey(key, mode)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(key, true, true, true),
    mode,
    true
  )
end

local snip_available = vim.fn['vsnip#available']
local snip_jumpable = vim.fn['vsnip#jumpable']

local cmp = require'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },

  formatting = {
    format = require'lspkind'.cmp_format({
      with_text = true,
      menu = {
        buffer = '[﬘ Buf]',
        nvim_lsp = '[ LSP]',
        luasnip = '[ LSnip]',
        snippet = '[ VSnip]',
        nvim_lua = '[ Lua]',
        cmp_tabnine = '[ TN]',
        path = '[פּ Path]',
      },
    })
  },

  mapping = {
    ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-y>'] = cmp.config.disable,
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    -- Accept currently selected item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif snip_available() == 1 then
        feedkey('<Plug>(vsnip-expand-or-jump)', '')
      else
        fallback()
      end
    end, { 'i', 'c' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif snip_jumpable(-1) == 1 then
        feedkey('<Plug>(vsnip-jump-prev)', '')
      end
    end, { 'i', 'c' }),
  },

  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'cmp_tabnine' },
    { name = 'buffer' },
  },
}

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = {
    { name = 'path' },
    { name = 'cmdline', max_item_count = 30 },
  },
})

EOF
