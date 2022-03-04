" nvim-lspconfig.rc.vim
"=============================================================================
lua<<EOF

local is_mac = vim.fn['IsMac']() == 1
local is_windows = vim.fn['IsWindows']() == 1

local servers = {
  'bashls',                -- Bash
  'cmake',                 -- CMake
  'clangd',                -- C/C++
  'csharp_ls',             -- C#
  'cssls',                 -- CSS
  'dockerls',              -- Docker
  'html',                  -- HTML
  'jsonls',                -- JSON
  'tsserver',              -- JavaScript/TypeScript
  'sumneko_lua',           -- Lua
  'remark_ls',             -- Markdown
  'intelephense',          -- PHP
  'powershell_es',         -- PowerShell
  'jedi_language_server',  -- Python
  'sqlls',                 -- SQL
  'taplo',                 -- TOML
  'vimls',                 -- VimL
  'lemminx',               -- XML
  'yamlls',                -- YAML
}

if is_mac then
  -- Swift
  table.insert(servers, 'sourcekit')
end

if not is_windows then
  -- Ruby
  -- NOTE: On Windows, MSYS2 is required, so exclude it on Windows.
  table.insert(servers, 'solargraph')
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require'cmp_nvim_lsp'.update_capabilities(capabilities)

local function on_attach(client, bufnr)
  -- disable formatting
  client.resolved_capabilities.document_formatting = false

  -- key mappings
  local mappings = {
    {
      modes = { 'n' },
      mappings = {
        ['<C-f>'] = [[<Cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>]],
        ['<C-b>'] = [[<Cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>]],
        ['<C-k>'] = [[<Cmd>Lspsaga diagnostic_jump_prev<CR>]],
        ['<C-j>'] = [[<Cmd>Lspsaga diagnostic_jump_next<CR>]],
        ['K'] = [[<Cmd>Lspsaga hover_doc<CR>]],
        ['gD'] = [[<Cmd>lua vim.lsp.buf.declaration()<CR>]],
        ['gd'] = [[<Cmd>Lspsaga preview_definition<CR>]],
        ['gi'] = [[<Cmd>lua vim.lsp.buf.implementation()<CR>]],
        ['gq'] = [[<Cmd>lua vim.diagnostic.set_loclist()<CR>]],
        ['gr'] = [[<Cmd>Lspsage lsp_finder<CR>]],
        ['gs'] = [[<Cmd>Lspsaga signature_help<CR>]],
        ['gy'] = [[<Cmd>lua vim.lsp.buf.type_definition()<CR>]],
        ['<Leader>rn'] = [[<Cmd>Lspsaga rename<CR>]],
        ['<Leader>cc'] = [[<Cmd>lua require('lspsaga.diagnostic').show_cursor_diagnostics()<CR>]],
        ['<Leader>cd'] = [[<Cmd>Lspsaga show_line_diagnostics<CR>]],
      },
    },
    {
      modes = { 'n', 'x' },
      mappings = {
        ['<Leader>ca'] = [[<Cmd>Lspsage code_action<CR>]],
      },
    },
  }

  local opts = {
    noremap = true,
    silent = true,
  }
  for _, maps in ipairs(mappings) do
    for _, mode in ipairs(maps.modes) do
      for key, command in pairs(maps.mappings) do
        vim.api.nvim_buf_set_keymap(bufnr, mode, key, command, opts)
      end
    end
  end
end

local installer = require'nvim-lsp-installer'
installer.settings {
  ui = {
    icons = {
      server_installed = "",
      server_pending = "",
      server_uninstalled = "",
    },
  },
}

for _, name in ipairs(servers) do
  local available, server = installer.get_server(name)
  if available then
    if not server:is_installed() then
      server:install()
    end
  else
    print('[LSP]: Not available "' .. name .. '".')
  end
end

installer.on_server_ready(function(server)
  local options = {
    on_attach = on_attach,
    --capabilities = setup_capabilities(),
    capabilities = capabilities,
    root_dir = vim.loop.cwd,
  }

  -- for Lua
  if server.name == 'sumneko_lua' then
    options.settings = {
      Lua = {
        diagnostics = {
          globals = {
            'vim',
            'describe',
            'it',
          },
        },
        workspace = {
          library = {
            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
          },
        },
      },
    }
  end

  server:setup(options)
  vim.cmd('do User LspAttachBuffers')
end)

EOF
