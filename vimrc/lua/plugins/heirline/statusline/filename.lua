local badge = require('plugins/heirline/badge')
local core = require('core')
local utils = require('heirline/utils')

local block = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
}

local flags = {
  {
    condition = function()
      return vim.bo.modifiable and not vim.bo.readonly
    end,
    provider = '',
    hl = { fg = 'soft_blue' },
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = '',
    hl = { fg = 'soft_red' },
  },
}

local icon = {
  init = function(self)
    self.icon, self.icon_color = core.get_icon(self.filename)
  end,
  provider = function(self)
    return self.icon
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

local filename = {
  provider = function(self)
    return badge.normalize_path(self.filename)
  end,
  hl = { fg = 'grayish_yellow' },
}

local modifer = {
  condition = function()
    return vim.bo.modified
  end,
  provider = '[+]',
  hl = { fg = 'soft_red' },
}

return utils.insert(block,
  flags,
  { provider = ' %n ' }, -- Buffer number
  icon,
  { provider = ' ' },
  filename,
  modifer
)
