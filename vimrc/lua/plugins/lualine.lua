-- plugin: lualine.nvim
-- see: https://github.com/nvim-lualine/lualine.nvim

local badge = require('badge')
local vfiler = require('vfiler')

-- Maximum number of directories in filepath
local badge_statusline_filepath_max_dirs = 0

-- Maximum number of characters in each directory
local badge_statusline_dir_max_chars = 5

local M = {}

-- Color table for highlights
local colors = {
  base03  = '#002b36',
  base02  = '#073642',
  base01  = '#586e75',
  base00  = '#657b83',
  base0   = '#839496',
  base1   = '#93a1a1',
  base2   = '#eee8d5',
  base3   = '#fdf6e3',
  yellow  = '#b58900',
  orange  = '#cb4b16',
  red     = '#dc322f',
  magenta = '#d33682',
  violet  = '#6c71c4',
  blue    = '#268bd2',
  cyan    = '#2aa198',
  green   = '#859900',

	active = {
		paste = '#98be65',
		filepath = '#D7D7BC',
	},
	filemode = {
		modified = '#ec5f67',
		readonly = '#ec5f67',
	},
}

-- Customized theme based on 'solarized_dark'.
local theme = {
  normal = {
    a = {fg = colors.base03, bg = colors.blue, gui = 'bold'},
    b = {fg = colors.base1, bg = colors.base02},
    c = {fg = colors.base1, bg = colors.base02},
  },
  insert = {a = {fg = colors.base03, bg = colors.green, gui = 'bold'}},
  visual = {a = {fg = colors.base03, bg = colors.magenta, gui = 'bold'}},
  replace = {a = {fg = colors.base03, bg = colors.red, gui = 'bold'}},
  inactive = {
    a = {fg = colors.base0, bg = colors.base02, gui = 'bold'},
    b = {fg = colors.base0, bg = colors.base02 },
    c = {fg = colors.base0, bg = colors.base02 },
  },
}

-- Section conditions
local conditions = {
  hide_in_width = function(width)
    return function() return vim.fn.winwidth(0) > width end
  end,
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end
}

-- Detect quickfix vs. location list
local function is_loclist()
  return vim.fn.getloclist(0, {filewinid = 1}).filewinid ~= 0
end

-- Extension: Quickfix
local extension_quickfix = {
  sections = {
    lualine_a = {
      {
        function()
          local pad = vim.g.global_symbol_padding or ' '
          local q = '' .. pad
          local l = '' .. pad
          return is_loclist() and l..'Location List' or q..'Quickfix List'
        end,
        padding = { left = 1, right = 0 },
      },
      {
        function()
          if is_loclist() then
            return vim.fn.getloclist(0, {title = 0}).title
          end
          return vim.fn.getqflist({title = 0}).title
        end
      },
    },
    lualine_z = {
      function() return '%l/%L' end
    },
  },
  filetypes = {'qf'},
}

-- Extension: File-explorer
local extension_file_explorer = {
  sections = {
    lualine_a = {
      {
        function()
          return badge.special_name(0)
        end,
        separator = {left = '', right = ' '},
        padding = 0,
      },
    },
    lualine_b = {
      {
        vfiler.status,
        padding = 0
      },
    },
  },
  inactive_sections = {
    lualine_a = {
      function()
        return badge.special_name(0)
      end,
    },
    lualine_b = {
      {
        vfiler.status,
        padding = {left = 1},
      },
    },
  },
  filetypes = {'vfiler'},
}

-- Extension: Only name and line-count
local extension_line_count = {
  sections = {
    lualine_a = {
      {
        function()
          return badge.special_name(0)
        end,
        separator = {left = '', right = ' '},
        padding = 0
      },
    },
    lualine_z = {
      {
        function() return '%l/%L' end,
        separator = {left = '', right = ' '},
      },
    },
  },
  inactive_sections = {
    lualine_a = {
      function()
        return badge.special_name(0)
      end,
    },
    lualine_z = {
      function() return '%l/%L' end
    },
  },
  filetypes = {'Trouble', 'DiffviewFiles', 'NeogitStatus', 'Outline'},
}

function M.setup()
  local navic = require('nvim-navic')
  navic.setup {
    highlight = false,
  }

  local config = {
    options = {
      theme = theme,
      always_divide_middle = false,
      component_separators = '',
      section_separators = {left = '', right = ''},
    },

    extensions = {
      extension_quickfix,
      extension_file_explorer,
      extension_line_count,
    },

    -- ACTIVE STATE --
    sections = {
      lualine_a = {
        {
          'mode',
          separator = {left = '', right = ' '},
          padding = 0,
        },
      },
      lualine_b = {
        -- Paste mode sign
        {
          function()
            return vim.go.paste and '=' or ''
          end,
          padding = 0,
          color = {fg = colors.active.paste},
        },
        -- Readonly or zoomed
        {
          function()
            return badge.filemode('#', '🔒', '🔎')
          end,
          padding = 0,
          color = {fg = colors.filemode.readonly},
        },
        -- Buffer number
        {
          function() return '%n' end,
          padding = 0
        },
        -- Modified sign
        {
          function()
            return badge.modified('+')
          end,
          padding = 0,
          color = {fg = colors.filemode.modified},
        },
        -- File icon
        {
          function()
            local data = badge.icon_data(0)
            return data.icon
          end,
          cond = conditions.buffer_not_empty,
          padding = {left = 1},
          color = function()
            local data = badge.icon_data(0)
            return {fg = data.color}
          end,
        },
        -- File path
        {
          function()
            return badge.filepath(
              0,
              badge_statusline_filepath_max_dirs,
              badge_statusline_dir_max_chars
            )
          end,
          cond = conditions.buffer_not_empty,
          padding = {left = 1},
          color = {fg = colors.active.filepath},
        },
        -- Border
        {
          function () return '' end,
          padding = {left = 1, right = 0},
        },
      },
      lualine_c = {
        -- Lsp server name
        {
          badge.lsp_server,
          icon = ' LSP:',
        },
        -- Diagnostics
        {
          'diagnostics',
          sources = {'nvim_diagnostic'},
          symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '},
          padding = 0,
        },
        -- Start truncating here
        {
          function() return '%<' end,
          padding = {left = 0, right = 0}
        },
        -- LSP to show your current context.
        {
          navic.get_location,
          cond = navic.is_available,
        },
        -- Whitespace trails
        {
          function()
            return badge.trails('␣')
          end,
          padding = {left = 1, right = 0}
        },
      },
      lualine_x = {
        -- Git branch
        {
          'branch',
          icon = '',
          cond = conditions.check_git_workspace,
          padding = {left = 1, right = 0},
        },
        -- Git status
        {
          'diff',
          symbols = {
            added = '₊',
            modified = '∗',
            removed = '₋'
          },
          cond = conditions.hide_in_width(60),
          padding = {left = 1, right = 0},
        },
      },
      lualine_y = {
        -- Border
        {
          function () return '' end,
          cond = conditions.hide_in_width(60),
          padding = 1,
        },
        -- Encoding
        {
          'encoding',
          fmt = string.upper,
          cond = conditions.hide_in_width(60),
          separator = '│',
          padding = {left = 0, right = 1},
        },
        -- File format
        {
          'fileformat',
          fmt = string.upper,
          icons_enabled = false,
          cond = conditions.hide_in_width(60),
          separator = '│',
          padding = 1,
        },
        -- File type
        {
          function() return vim.bo.filetype end,
          cond = conditions.hide_in_width(60),
          padding = 1,
        },
      },
      lualine_z = {
        {
          badge.progress,
          separator = {left = '', right = ''},
          padding = 0,
        },
      },
    },

    -- INACTIVE STATE --
    inactive_sections = {
      lualine_a = {
        {
          function()
            return badge.filepath(
              0,
              badge_statusline_filepath_max_dirs,
              badge_statusline_dir_max_chars
            )
          end,
          padding = {left = 1, right = 0}
        },
        {
          function()
            return badge.modified('+')
          end,
        },
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {
        {
          function() return vim.bo.filetype end,
          padding = 1,
        },
      }
    }
  }

  vim.g.qf_disable_statusline = true
  require('lualine').setup(config)
end

return M
