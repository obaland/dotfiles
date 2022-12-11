-- plugin: bqf
-- see: https://github.com/kevinhwang91/nvim-bqf

local M = {}

local max_file_size = 100 * 1024 -- 100kb

function M.setup()
  require('bqf').setup({
    auto_resize_height = false,
    preview = {
      auto_preview = true,
      should_preview_cb = function(bufnr)
        -- file size greater than 'max_file_size' can't be previewed automatically
        local filename = vim.api.nvim_buf_get_name(bufnr)
        local fsize = vim.fn.getfsize(filename)
        if fsize > max_file_size then
          return false
        end
        return true
      end,
    }
  })
end

return M
