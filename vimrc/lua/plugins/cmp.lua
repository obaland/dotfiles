-- plugin: nvim-cmp
-- see: https://github.com/hrsh7th/nvim-cmp

local M = {}

-- cmp sources
local cmp_sources = {
  buffer = { name = 'buffer' },
  cmdline = {
    name = 'cmdline',
    max_item_count = 30,
  },
  nvim_lsp = { name = 'nvim_lsp' },
  nvim_lua = { name = 'nvim_lua' },
  path = { name = 'path' },
  emoji = { name = 'emoji' },
  snippet = { name = 'luasnip' },
  tmux = {
    name = 'tmux',
    option = { all_panes = true },
  },
  latex = { name = 'latex_symbols' },
}

-- Source setup. Helper function for cmp source presets.
local function cmp_get_sources(arr)
  local sources = {}
  for _, name in ipairs(arr) do
    local index = #sources + 1
    sources[index] = cmp_sources[name]
  end
  return sources
end

-- Labels for completion candidates.
local completion_labels = {
  buffer = '[﬘ Buf]',
  emoji = '[Emoji]',
  nvim_lsp = '[ LSP]',
  nvim_lua = '[ Lua]',
  luasnip = '[ LSnip]',
  path = '[פּ Path]',
  tmux = '[Tmux]',
}

-- Default completion kind symbols.
local kind_presets = {
  Text = '', --   𝓐
  Method = '', --  ƒ
  Function = '', -- 
  Constructor = '', --   
  Field = '', --  ﴲ ﰠ   
  Variable = '', --   
  Class = '', --  ﴯ 𝓒
  Interface = '', -- ﰮ    
  Module = '', --   
  Property = '襁', -- ﰠ 襁
  Unit = '', --  塞
  Value = '',
  Enum = '練', -- 練 ℰ 
  Keyword = '', --   🔐
  Snippet = '', -- ﬌  ⮡ 
  Color = '',
  File = '', --  
  Reference = '', --  
  Folder = '', --  
  EnumMember = '',
  Constant = '', --  
  Struct = '', --   𝓢 פּ
  Event = '', --  🗲
  Operator = '', --   +
  TypeParameter = '', --  𝙏
}

-- Detect if words are before cursor position.
local function has_words_before()
  if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local lines = vim.api.nvim_buf_get_lines(0, line - 1, line, true)
  return col ~= 0 and lines[1]:sub(col, col):match('%s') == nil
end

-- Feed proper terminal codes
local function feedkey(key, mode)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(key, true, true, true),
    mode,
    true
  )
end

-- For LSP integration, see lspconfig.lua

function M.setup()
  local cmp = require('cmp')
  local luasnip = require('luasnip')

  cmp.setup({
    -- Set default cmp sources
    sources = cmp_get_sources({
      'nvim_lsp',
      'buffer',
      'path',
      'snippet',
      'tmux',
    }),

    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },

    mapping = cmp.mapping.preset.insert({
      ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
      ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
      ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
      ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable,
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = false,
      }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          feedkey('<Plug>(luasnip-expand-or-jump)', '')
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          feedkey('<Plug>(luasnip-jump-prev)', '')
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),

    window = {
      completion = cmp.config.window.bordered({
        border = 'rounded',
      }),
      documentation = cmp.config.window.bordered({
        border = 'rounded',
      }),
    },

    formatting = {
      format = function(entry, vim_item)
        -- Prepend with a fancy icon
        local symbol = kind_presets[vim_item.kind]
        if symbol ~= nil then
          vim_item.kind = symbol
            .. (vim.g.global_symbol_padding or ' ')
            .. vim_item.kind
        end

        -- Set menu source name
        if completion_labels[entry.source.name] then
          vim_item.menu = completion_labels[entry.source.name]
        end

        vim_item.dup = ({
          nvim_lua = 0,
          buffer = 0,
        })[entry.source.name] or 1

        return vim_item
      end,
    },
  })

  -- Completion sources according to specific file-types.
  cmp.setup.filetype({ 'markdown', 'help', 'text' }, {
    sources = cmp_get_sources({
      'emoji',
      'nvim_lsp',
      'buffer',
      'path',
      'snippet',
      'tmux',
    }),
  })

  cmp.setup.filetype({ 'lua' }, {
    sources = cmp_get_sources({
      'nvim_lua',
      'nvim_lsp',
      'buffer',
      'path',
      'snippet',
      'tmux',
    }),
  })

  -- Completion sources according to specific command line
  cmp.setup.cmdline('/', {
    sources = cmp_get_sources({ 'buffer' }),
  })

  cmp.setup.cmdline(':', {
    sources = cmp_get_sources({ 'path', 'cmdline' }),
  })

  -- Insert `(` after select function or method item.
  local autopairs = require('nvim-autopairs/completion/cmp')
  cmp.event:on('confirm_done', autopairs.on_confirm_done())
end

return M
