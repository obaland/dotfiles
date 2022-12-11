-- plugin: nvim-cmp
-- see: https://github.com/hrsh7th/nvim-cmp

local M = {}

-- VSnip functions
local vsnip_available = vim.fn['vsnip#available']
local vsnip_jumpable = vim.fn['vsnip#jumpable']

-- cmp sources
local cmp_sources = {
  buffer = {name = 'buffer'},
  cmdline = {
    name = 'cmdline',
    max_item_count = 30,
  },
  nvim_lsp = {name = 'nvim_lsp'},
  nvim_lua = {name = 'nvim_lua'},
  path = {name = 'path'},
  emoji = {name = 'emoji'},
  vsnip = {name = 'vsnip'},
  tabnine = {name = 'cmp_tabnine'},
  tmux = {
    name = 'tmux',
    option = {all_panes = true},
  },
  latex = {name = 'latex_symbols'},
}

-- Source setup. Helper function for cmp source presets.
local function cmp_get_sources(arr)
  local sources = {}
  for _, name in ipairs(arr) do
    local index = #sources + 1
    if name == 'tabnine' then
      local ok, _ = pcall(require, 'cmp-tabnine')
      if ok then
        sources[index] = cmp_sources[name]
      end
    else
      sources[index] = cmp_sources[name]
    end
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
  snippet = '[ VSnip]',
  cmp_tabnine = '[ TN]',
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
  Snippet = '⮡', -- ﬌  ⮡ 
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
    vim.api.nvim_replace_termcodes(key, true, true, true), mode, true
  )
end

-- For LSP integration, see lspconfig.lua

function M.setup()
  local cmp = require('cmp')
  cmp.setup({
    -- Set default cmp sources
    sources = cmp_get_sources({
      'nvim_lsp',
      'tabnine',
      'buffer',
      'path',
      'vsnip',
      'tmux',
    }),

    snipeet = {
      expand = function(args)
        -- Using https://github.com/hrsh7th/vim-vsnip for snippets.
        vim.fn['vsnip#anonymous'](args.body)
      end,
    },

    mapping = cmp.mapping.preset.insert({
      ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 'c'}),
      ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 'c'}),
      ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(), {'i', 'c'}),
      ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i', 'c'}),
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
      ['<C-y>'] = cmp.config.disable,
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
      ['<CR>'] = cmp.mapping.confirm({select = false}),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif vsnip_available() == 1 then
          feedkey('<Plug>(vsnip-expand-or-jump)', '')
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, {'i', 's'}),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vsnip_jumpable(-1) == 1 then
          feedkey('<Plug>(vsnip-jump-prev)', '')
        elseif has_words_before() then
          cmp.coplete()
        else
          fallback()
        end
      end, {'i', 's'}),
    }),

    window = {
      completion = cmp.config.window.bordered({
        border = 'single',
      }),
      documentation = cmp.config.window.bordered({
        border = 'single',
      })
    },

    formatting = {
      format = function(entry, vim_item)
        -- Prepend with a fancy icon
        local symbol = kind_presets[vim_item.kind]
        if symbol ~= nil then
          vim_item.kind = symbol ..
            (vim.g.global_symbol_padding or ' ') .. vim_item.kind
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
  cmp.setup.filetype({'markdown', 'help', 'text'}, {
    sources = cmp_get_sources(
      {'emoji', 'nvim_lsp', 'tabnine', 'buffer', 'path', 'vsnip', 'tmux'}
    )
  })

  cmp.setup.filetype({'lua'}, {
    sources = cmp_get_sources(
      {'nvim_lua', 'nvim_lsp', 'tabnine', 'buffer', 'path', 'vsnip', 'tmux'}
    )
  })

  -- Completion sources according to specific command line
  cmp.setup.cmdline('/', {
    sources = cmp_get_sources({'buffer'}),
  })

  cmp.setup.cmdline(':', {
    sources = cmp_get_sources({'path', 'cmdline'})
  })
end

return M
