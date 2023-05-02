local common = require('plugins/heirline/statusline/common')

return {
  {
    -- File encoding
    condition = function()
      return vim.bo.fileencoding ~= ''
    end,
    common.border,
    { provider = function() return string.upper(vim.bo.fileencoding) end },
  },
  common.border,
  {
    -- File format
    provider = function() return string.upper(vim.bo.fileformat) end,
  },
  {
    -- File type
    condition = function()
      return vim.bo.filetype ~= ''
    end,
    common.border,
    { provider = function() return vim.bo.filetype end },
  },
}
