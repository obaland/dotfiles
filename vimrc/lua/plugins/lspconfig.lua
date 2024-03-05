-- plugin: nvim-lspconfig
-- see: https://github.com/neovim/nvim-lspconfig
--      https://github.com/williamboman/mason.nvim
--      https://github.com/williamboman/mason-lspconfig.nvim

local M = {}

local augroup = vim.api.nvim_create_augroup('user_lspconfig', {})

-- Combine base config for each server
local function make_config(server)
  -- Setup base config for each server.
  local options = {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
  }

  -- Merge user-defined lsp settings.
  local ok, user_lsp = pcall(require, 'lsp/' .. server)
  if ok then
    local user_config = user_lsp.make_config(options)
    for key, value in pairs(user_config) do
      options[key] = value
    end
  end
  return options
end

-- Buffer attached
local function on_attach(client, bufnr)
  local function map_buf(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  -- Short-circuit for Helm template files
  local filetype = vim.bo[bufnr].filetype
  if
    vim.bo[bufnr].buftype ~= ''
    or filetype == 'helm'
    or filetype == 'vfiler'
  then
    vim.diagnostic.disable(bufnr)
    vim.defer_fn(function()
      vim.diagnostic.reset(nil, bufnr)
    end, 1000)
    return
  end

  -- Disable diagnostics if buffer/global indicator is on
  if vim.b[bufnr].diagnostic_disabled or vim.g.diagnostic_disabled then
    vim.diagnostic_disable(bufnr)
  end

  -- Keyboard mappings
  -- stylua: ignore start
  local opts = { noremap = true, silent = true }
  map_buf('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  map_buf('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  map_buf('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  map_buf('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  map_buf('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  map_buf('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  map_buf('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  map_buf('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  map_buf('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  map_buf('n', '<leader>wl', '<cmd>lua =vim.lsp.buf.list_workspace_folders()<CR>', opts)
  map_buf('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  map_buf('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  map_buf('x', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  map_buf('n', '<Leader>ce', '<cmd>lua vim.diagnostic.open_float({source=true})<CR>', opts)

  -- Call hierarchy
  map_buf('n', '<Leader>ci', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
  map_buf('n', '<Leader>co', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)
  -- stylua: ignore end

  -- Disable formatting
  client.server_capabilities.document_formatting = false

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
    -- client.config.flags.debounce_text_changes  = vim.opt.updatetime:get()
  end

  -- Set autocommands conditional on server capabilities
  if client.supports_method('textDocument/documentHighlight') then
    vim.api.nvim_create_autocmd('CursorHold', {
      group = augroup,
      callback = function(_)
        vim.lsp.buf.document_highlight()
      end,
      buffer = bufnr,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = augroup,
      callback = function(_)
        vim.lsp.buf.clear_references()
      end,
      buffer = bufnr,
    })
  end
end

function M.setup()
  -- Config
  vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    virtual_text = {
      spacing = 4,
      prefix = '●',
    },
    float = {
      border = 'rounded',
    },
  })

  -- Diagnostics signs and hightlights
  local signs = { Error = '✘', Warn = '', Hint = '', Info = 'ⁱ' }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
  end

  -- Configure LSP Handlers
  -- Configure help hover handler
  vim.lsp.handlers['textDocument/hover'] =
    vim.lsp.with(vim.lsp.handlers.hover, {
      border = 'rounded',
    })

  -- Configure signature help handler
  vim.lsp.handlers['textDocument/signatureHelp'] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

  -- Setup language servers using nvim-lspconfig
  local servers = require('mason-lspconfig').get_installed_servers()
  local lspconfig = require('lspconfig')
  for _, server in pairs(servers) do
    local options = make_config(server)
    lspconfig[server].setup(options)
  end

  -- Reload if files were supplied in command-line arguments
  if
    vim.fn.argc() > 0
    and vim.fn.has('vim_starting')
    and not vim.o.modified
  then
    -- triggers the FileType autocmd that starts the servers
    vim.cmd('windo e')
  end

  -- global custom location-list diagnostics window toggle.
  local args = { noremap = true, silent = true }
  local function nmap(lhs, rhs)
    vim.api.nvim_set_keymap('n', lhs, rhs, args)
  end

  nmap('<C-k>', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
  nmap('<C-j>', '<cmd>lua vim.diagnostic.goto_next()<CR>')

  vim.api.nvim_create_autocmd('DiagnosticChanged', {
    group = augroup,
    callback = function(_)
      vim.diagnostic.setloclist({ open = false })
    end,
  })

  -- Create an attach event for each LSP.
  require('core').api.on_lsp_attach(on_attach, augroup)
end

return M
