-- plugin: lsp_signature.nvim
-- see: https://github.com/ray-x/lsp_signature.nvim

local M = {}

function M.setup()
  -- OmniSharp が返す不正な activeSignature を補正する.
  if not vim.g.omnisharp_signature_help_normalizer_installed then
    vim.g.omnisharp_signature_help_normalizer_installed = true

    local org_buf_request = vim.lsp.buf_request
    vim.lsp.buf_request = function(bufnr, method, params, handler, ...)
      if method ~= 'textDocument/signatureHelp'
          or type(handler) ~= 'function' then
        return org_buf_request(bufnr, method, params, handler, ...)
      end

      local normalized_handler = function(err, result, ctx, config)
        if not err
            and result
            and type(result.signatures) == 'table'
            and #result.signatures > 0
            and ctx
            and ctx.client_id then

          local client = vim.lsp.get_client_by_id(ctx.client_id)
          if client and client.name == 'omnisharp' then
            local index = result.activeSignature
            if type(index) ~= 'number'
                or index < 0
                or index >= #result.signatures then
              result.activeSignature = 0
            end
          end
        end
        return handler(err, result, ctx, config)
      end

      return org_buf_request(
        bufnr, method, params, normalized_handler, ...
      )
    end
  end

  -- プラグインの初期化.
  require('lsp_signature').setup({
    hint_prefix = '󰛩 ',
    handler_opts = {
      border = 'rounded'
    },

    ignore_error = function(err, ctx, config)
      if type(err) ~= 'table' or not ctx or not ctx.client_id then
        return false
      end

      local client = vim.lsp.get_client_by_id(ctx.client_id)

      -- TODO: OmniSharp 以外のエラーは従来どおり表示する.
      if not client or client.name ~= 'omnisharp' then
        return false
      end

      -- OmniSharp でのエラー対処
      if err.code ~= -32603
          and err.code_name ~= 'InternalError' then
        return false
      end

      local message = tostring(err.message or '')

      -- シグニチャ生成処理の NullReferenceException のみ無視する.
      return message:find('System.NullReferenceException', 1, true) ~= nil
        and message:find('OmniSharp.Roslyn.CSharp.Services.Signatures.SignatureHelpService', 1, true) ~= nil
    end,
  })
end

return M
