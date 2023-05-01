local core = require('core')
local conditions = require('heirline/conditions')
local utils = require('heirline/utils')

local M = {}

local function statuslines()
  -- Delimiters
  local delimiter_a = { '', '' }

  -- Align
  local align = { provider = '%=' }

  -- Mode
  local mode = {
    init = function(self)
      self.mode = vim.fn.mode(1)
    end,

    static = {
      fg = 'base03',
      mode_names = {
        n = 'NORMAL',
        no = 'O-PENDING',
        nov = 'O-PENDING',
        noV = 'O-PENDING',
        ['no\22'] = 'O-PENDING',
        niI = 'NORMAL',
        niR = 'NORMAL',
        niV = 'NORMAL',
        nt = 'NORMAL',
        v = 'VISUAL',
        vs = 'VISUAL',
        V = 'V-LINE',
        Vs = 'V-LINE',
        ['\22'] = 'V-BLOCK',
        ['\22s'] = 'V-BLOCK',
        s = 'SELECT',
        S = 'S-LINE',
        ['\19'] = 'S-BLOCK',
        i = 'INSERT',
        ic = 'INSERT',
        ix = 'INSERT',
        R = 'REPLACE',
        Rc = 'REPLACE',
        Rx = 'REPLACE',
        Rv = 'V-REPLACE',
        Rvc = 'V-REPLACE',
        Rvx = 'V-REPLACE',
        c = 'COMMAND',
        cv = 'EX',
        ce = 'EX',
        r = 'REPLACE',
        rm = 'MORE',
        ['r?'] = 'CONFIRM',
        ['!'] = 'SHELL',
        t = 'TERMINAL',
      },
    },

    provider = function(self)
      return self.mode_names[self.mode]
    end,

    hl = function(self)
      local color = self:mode_color()
      return { fg = 'base03', bg = color, bold = true }
    end,
  }

  local file_flags = {
    {
      condition = function()
        return vim.bo.modified
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

  -- Ruler
  local ruler = {
    -- %l: current line number
    -- %L: number of lines in the buffer
    -- %c: column number
    -- %P: percentage through file of displayed window
    provider = '%7(%l/%3L%):%2c %P',
    hl = { fg = 'base03' },
  }

  return {
    hl = { bg = 'base02' },
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
        local mode = conditions.is_active() and vim.fn.mode() or 'n'
        return self.mode_colors_map[mode]
      end,
    },
    {
      -- Mode
      utils.surround(delimiter_a, function(self)
        return self:mode_color()
      end, mode),
    },
    align,
    {
      -- Ruler
      utils.surround(delimiter_a, function(self)
        return self:mode_color()
      end, ruler),
    },
  }
end

function M.setup()
  require('heirline').setup({
    statusline = statuslines(),
    opts = {
      colors = core.get_colors(),
    },
  })
end

return M
