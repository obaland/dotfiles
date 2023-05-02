return {
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
