local badge = require('plugins/heirline/badge')

local M = {}

function M.components()
  local conditions = require('heirline/conditions')
  local utils = require('heirline/utils')

  local extension_filetypes = {
    vfiler          = { icon = '', name = 'vfiler' },
    undotree        = { icon = '', name = 'undotree' },
    qf              = { icon = '', name = 'List' },
    TelescopePrompt = { icon = '', name = 'Telescope' },
    Trouble         = { icon = '', name = 'Trouble' },
    DiffviewFiles   = { icon = '', name = 'DiffviewFiles' },
    Outline         = { icon = '', name = 'Outline' },
    NeogitStatus    = { icon = '', name = 'NeogitStatus' },
    ['mason.nvim']  = { icon = '', name = 'Mason' },
    spectre_panel   = { icon = '', name = 'Spectre' },
  }

  -- Delimiters
  local delimiter_a = { '', '' }

  -- Components
  local common = require('plugins/heirline/statusline/common')
  local diagnostics = require('plugins/heirline/statusline/diagnostics')
  local git = require('plugins/heirline/statusline/git')
  local mode = require('plugins/heirline/statusline/mode')
  local filename = require('plugins/heirline/statusline/filename')
  local filetype = require('plugins/heirline/statusline/filetype')
  local ruler = require('plugins/heirline/statusline/ruler')

  -- Normal statusline
  local statusline = {
    active = {
      static = {
        mode_colors_map = {
          n = 'blue',
          i = 'green',
          v = 'magenta',
          V = 'magenta',
          ['\22'] = 'magenta',
          c = 'orange',
          s = 'purple',
          S = 'purple',
          ['\19'] = 'purple',
          R = 'red',
          r = 'red',
          ['!'] = 'orange',
          t = 'orange',
        },
        mode_color = function(self)
          local m = conditions.is_active() and vim.fn.mode() or 'n'
          return self.mode_colors_map[m]
        end,
      },
      {
        -- Mode
        utils.surround(delimiter_a, function(self)
          return self:mode_color()
        end, mode),
      },
      common.space,
      filename,
      common.border,
      diagnostics,
      common.align,
      git,
      filetype,
      common.space,
      {
        -- Ruler
        utils.surround(delimiter_a, function(self)
          return self:mode_color()
        end, ruler),
      },
    },
    inactive = {
      {
        provider = function()
          local name = vim.api.nvim_buf_get_name(0)
          return ' ' .. badge.normalize_path(name)
        end,
      },
      common.align,
      {
        condition = function()
          return vim.bo.filetype ~= ''
        end,
        provider = function()
          return vim.bo.filetype .. ' '
        end,
      },
    },
  }

  -- Extension: vfiler statusline
  local extension_vfiler = {
    active = {
      {
        utils.surround(delimiter_a, 'blue', {
          provider = extension_filetypes.vfiler.icon .. ' vfiler',
        }),
        hl = { fg = 'base03' },
      },
      common.align,
      {
        provider = badge.project() .. ' ',
      },
    },
    inactive = {
      {
        provider = ' ' .. extension_filetypes.vfiler.icon .. ' vfiler',
      },
      common.align,
      {
        provider = badge.project() .. ' ',
      },
    },
    filetypes = { 'vfiler' }
  }

  -- Extension: Quickfix statusline
  local extension_quickfix = {
    active = {
      init = function(self)
        self.is_loclist = vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0
      end,
      common.space,
      {
        provider = function(self)
          local pad = vim.g.global_symbol_padding or ' '
          local q = '' .. pad
          local l = '' .. pad
          return self.is_loclist() and l..'Location List' or q..'Quickfix List'
        end,
      },
      {
        provider = function(self)
          if self.is_loclist then
            return vim.fn.getloclist(0, { title = 0 }).title
          end
          return vim.fn.getqflist({ title = 0 }).title
        end,
      }
    },
    filetypes = { 'qf' },
  }

  -- Extension: Only name and line-count
  local ex_filetypes = {}
  for ft, _ in pairs(extension_filetypes) do
    table.insert(ex_filetypes, ft)
  end
  local extension_line_count = {
    active = {
      {
        hl = { fg = 'base03' },
        {
          init = function(self)
            self.filetype = extension_filetypes[vim.bo.filetype]
          end,
          utils.surround(delimiter_a, 'blue', {
            provider = function(self)
              return self.filetype.icon .. ' ' .. self.filetype.name
            end,
          }),
        },
        common.align,
        {
          utils.surround(delimiter_a, 'blue', {
            provider = '%l/%L',
          }),
        },
      },
    },
    inactive = {
      {
        init = function(self)
          self.filetype = extension_filetypes[vim.bo.filetype]
        end,
        {
          provider = function(self)
            return ' ' .. self.filetype.icon .. ' ' .. self.filetype.name
          end,
        },
        common.align,
        {
          provider = '%l/%L'
        },
      },
    },
    filetypes = ex_filetypes,
  }

  return {
    hl = { bg = 'base02' },
    fallthrough = false,
    {
      condition = function()
        return conditions.buffer_matches({
          filetype = extension_vfiler.filetypes,
        })
      end,
      {
        condition = conditions.is_active,
        extension_vfiler.active,
      },
      {
        condition = conditions.is_not_active,
        extension_vfiler.inactive,
      },
    },
    {
      condition = function()
        return conditions.buffer_matches({
          filetype = extension_quickfix.filetypes,
        })
      end,
      extension_quickfix.active,
    },
    {
      condition = function()
        return conditions.buffer_matches({
          filetype = extension_line_count.filetypes,
        })
      end,
      {
        condition = conditions.is_active,
        extension_line_count.active,
      },
      {
        condition = conditions.is_not_active,
        extension_line_count.inactive,
      },
    },
    {
      condition = conditions.is_active,
      statusline.active,
    },
    {
      condition = conditions.is_not_active,
      statusline.inactive,
    },
  }
end

return M
