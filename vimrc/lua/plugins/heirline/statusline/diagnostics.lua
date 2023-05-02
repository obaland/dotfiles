local conditions = require('heirline/conditions')

return {
  condition = conditions.has_diagnostics,
  static = {
    icons = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
  },
  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  end,
  update = { 'DiagnosticChanged', 'BufEnter' },
  {
    provider = function(self)
      return self.errors > 0 and (self.icons.error .. self.errors .. ' ')
    end,
    hl = 'DiagnosticError',
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.icons.warn .. self.warnings .. ' ')
    end,
    hl = 'DiagnosticWarn',
  },
  {
    provider = function(self)
      return self.info > 0 and (self.icons.info .. self.info .. ' ')
    end,
    hl = 'DiagnosticInfo',
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.icons.hint .. self.hints)
    end,
    hl = 'DiagnosticHint',
  },
}
