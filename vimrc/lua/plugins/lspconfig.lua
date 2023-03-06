-- plugin: nvim-lspconfig
-- see: https://github.com/neovim/nvim-lspconfig
--      https://github.com/williamboman/mason.nvim
--      https://github.com/williamboman/mason-lspconfig.nvim
--      https://github.com/ray-x/lsp_signature.nvim
--      https://github.com/kosayoda/nvim-lightbulb

local core = require('core')

local M = {}

-- Combine base config for each server
local function make_config(server)
  -- Setup base config for each server.
  local options = {}
  options.on_attach = M.on_attach

  local exists, module = pcall(require, 'cmp_nvim_lsp')
  if exists then
    options.capabilities = module.default_capabilities()
  end

  -- Merge user-defined lsp settings.
  exists, module = pcall(require, 'lsp/' .. server)
  if exists then
    local user_config = module.config(options)
    for key, value in pairs(user_config) do
      options[key] = value
    end
  end
  return options
end

-- Buffer attached
function M.on_attach(client, bufnr)
  local function map_buf(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  -- Keyboard mappings
  local opts = {noremap = true, silent = true}
  map_buf('n', 'K', '<cmd>Lspsaga hover_doc<CR>', opts)

	-- Short-circuit for Helm template files
  local filetype = vim.bo[bufnr].filetype
	if vim.bo[bufnr].buftype ~= '' or filetype == 'helm' or filetype == 'vfiler' then
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

  map_buf('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  map_buf('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  map_buf('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  map_buf('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  map_buf('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  map_buf('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  map_buf('n', ',wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  map_buf('n', ',wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  map_buf('n', ',wl', '<cmd>lua =vim.lsp.buf.list_workspace_folders()<CR>', opts)
  map_buf('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  map_buf('n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  map_buf('x', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  map_buf('n', '<Leader>ce', '<cmd>lua vim.diagnostic.open_float({source=true})<CR>', opts)

  -- Disable formatting
  client.server_capabilities.document_formatting = false

  -- For nvim-navic to work, it needs attach to the lsp server.
  local exists, navic = pcall(require, 'nvim-navic')
  if exists then
    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end
  end

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
    -- client.config.flags.debounce_text_changes  = vim.opt.updatetime:get()
  end

  -- Set autocommands conditional on server capabilities
  if client.supports_method('textDocument/documentHighlight') then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
    ]], false)
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
  })

  -- Diagnostics signs and hightlights
  local signs = { Error = '✘', Warn = '', Hint = '', Info = 'ⁱ' }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = ''})
  end

  -- Configure LSP Handlers
  -- Configure help hover handler
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover, {border = 'rounded'}
  )

  -- Configure signature help handler
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {border = 'rounded'}
  )

  -- Configuration Plugins

  local neodev_ok, neodev = pcall(require, 'neodev')
  if neodev_ok then
    neodev.setup({})
  end

  -- Setup language servers using mason and mason-lspconfig
  local mason_ok, mason = pcall(require, 'mason')
  if mason_ok then
    mason.setup({
      ui = {
        icons = {
          package_installed = '',
          package_pending = '',
          package_uninstalled = '',
        },
      },
    })
    local mason_lspconfig = require('mason-lspconfig')
    mason_lspconfig.setup()

    local packages = mason_lspconfig.get_installed_servers()

    -- Setup language servers using nvim-lspconfig
    local lspconfig = require('lspconfig')
    for _, server in pairs(packages) do
      local options = make_config(server)
      lspconfig[server].setup(options)
    end
  end

  -- Reload if files were supplied in command-line arguments
  if vim.fn.argc() > 0 and vim.fn.has('vim_starting') and not vim.o.modified then
    -- triggers the FileType autocmd that starts the servers
    vim.cmd('windo e')
  end

  -- global custom location-list diagnostics window toggle.
  local args = {noremap = true, silent = true}
  local function nmap(lhs, rhs)
    vim.api.nvim_set_keymap('n', lhs, rhs, args)
  end

  nmap('<C-k>', '<cmd>lua require("lspsaga/diagnostic"):goto_prev()<CR>')
  nmap('<C-j>', '<cmd>lua require("lspsaga/diagnostic"):goto_next()<CR>')

  -- See https://github.com/kosayoda/nvim-lightbulb
  local lightbulb_ok, lightbulb = pcall(require, 'nvim-lightbulb')
  if lightbulb_ok then
    lightbulb.setup({ignore = {'null-ls'}})
    vim.api.nvim_exec([[
      augroup user_lspconfig
        autocmd!

        " See https://github.com/kosayoda/nvim-lightbulb
        autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()

        " Update loclist with diagnostics for the current file
        autocmd DiagnosticChanged * lua vim.diagnostic.setloclist({open = false})

        " Automatic diagnostic hover
        " autocmd CursorHold * lua require("user").diagnostic.open_float({focusable = false})
      augroup END
    ]], false)
  end
end

return M
