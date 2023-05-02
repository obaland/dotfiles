local conditions = require('heirline/conditions')
local utils = require('heirline/utils')

local git = {
  condition = conditions.is_git_repo,
  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changed = self.status_dict.added ~= 0
      or self.status_dict.removed ~= 0
      or self.status_dict.changed ~= 0
  end,
  static = {
    diff_icons = {
      added = '+',
      changed = '*',
      removed = '-',
    },
  },
}

local branch = {
  provider = function(self)
    return ' ' .. self.status_dict.head
  end,
  hl = { fg = 'green', bold = true },
}

local diff = {
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and (' '.. self.diff_icons.added .. count)
    end,
    hl = 'GitSignsAdd',
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and (' '.. self.diff_icons.changed .. count)
    end,
    hl = 'GitSignsChange',
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and (' '.. self.diff_icons.removed .. count)
    end,
    hl = 'GitSignsDelete',
  },
}

return utils.insert(git, branch, diff)
