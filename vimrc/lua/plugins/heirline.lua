local conditions = require('heirline/conditions')
local core = require('core')
local utils = require('heirline/utils')

local M = {}

local special_filetypes = {
  aerial = { icon = '', name = 'Outline' },
  ['aerial-nav'] = { icon = '󱣱', name = 'Navigation' },
  DiffviewFiles = { icon = '', name = 'DiffviewFiles' },
  mason = { icon = '', name = 'Mason' },
  NeogitStatus = { icon = '', name = 'NeogitStatus' },
  spectre_panel = { icon = '', name = 'Spectre' },
  TelescopePrompt = { icon = '', name = 'Telescope' },
  undotree = { icon = '', name = 'undotree' },
  startify = { icon = '󰙴', name = 'Welcome' },
}

local function line_count_format()
  return '%7(%l/%3L%)'
end

local function filepath(filename, max_dirs, dir_max_chars)
  if #filename < 1 then
    return 'N/A'
  end
  local name = core.normalize_path(filename)
  local parts = vim.split(name, '/', {})
  local dirs = {}
  while #parts > 1 do
    local dir = table.remove(parts, 1)
    if #parts < max_dirs then
      table.insert(dirs, dir:sub(1, dir_max_chars))
    end
  end
  local path = table.concat(dirs, '/')
  if #dirs > 0 then
    path = path .. '/'
  end
  path = path .. parts[1]
  return path
end

local function truncate_path(path, winwidth)
  local items = vim.split(path, '/', {})
  local displays = { table.remove(items) }
  local strwidth = vim.fn.strdisplaywidth(displays[1])

  for i = #items, 1, -1 do
    local item = items[i]
    local width = vim.fn.strdisplaywidth(item)
    if (strwidth + width + 1) > winwidth then
      break
    end
    table.insert(displays, 1, item)
    strwidth = strwidth + width + 1
  end

  return table.concat(displays, '/'), strwidth
end

local function project_root()
  local dir = core.project_root(0)
  local icon = ''
  if #dir > 0 then
    icon = ' '
  else
    dir = vim.fn.getcwd()
  end
  return icon .. vim.fn.fnamemodify(dir, ':t')
end

local function surround(component)
  return utils.surround({ '', '' }, 'russian_blue', component)
end

local component = {}

function component.border()
  return {
    provider = ' ┃ ',
    hl = { fg = 'base03' },
  }
end

function component.space()
  return { provider = ' ' }
end

function component.align()
  return { provider = '%=' }
end

-- Extensions
--============================================================================
local extensions = {}

-- vfiler
extensions.vfiler = {
  condition = function()
    return conditions.buffer_matches({ filetype = { 'vfiler' } })
  end,
  init = function(self)
    self.status = require('vfiler').status()
  end,
  {
    surround({ provider = ' vfiler' }),
    hl = { fg = 'blue' },
  },
  {
    provider = ' ' .. project_root(),
    hl = { fg = 'green', bold = true },
  },
  component.border(),
  {
    provider = function(self)
      local current = self.status.current_item
      if not current then
        return ''
      end
      local num = ('[%3d/%3d] '):format(
        current.number,
        self.status.num_items
      )
      return num .. current.path
    end,
    hl = { fg = 'white' },
  },
  component.align(),
}

-- Telescope
extensions.telescope = {
  condition = function()
    return conditions.buffer_matches({ filetype = { 'TelescopePrompt' } })
  end,
  {
    surround({ provider = ' Telescope' }),
    hl = { fg = 'blue' },
  },
  component.align(),
}

-- Mason
extensions.mason = {
  condition = function()
    return conditions.buffer_matches({ filetype = { 'mason' } })
  end,
  {
    surround({ provider = ' Mason' }),
    hl = { fg = 'blue' },
  },
  component.border(),
  {
    provider = function()
      local registry = require('mason-registry')
      return ("Installed: %d/%d"):format(
        #registry.get_installed_packages(),
        #registry.get_all_package_specs()
      )
    end,
    hl = { fg = 'white' },
  },
  component.align(),
  surround({
    provider = line_count_format(),
  }),
}

-- Quickfix
extensions.quickfix = {
  condition = function()
    return conditions.buffer_matches({ filetype = { 'qf' } })
  end,
  init = function(self)
    self.is_loclist = vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0
  end,
  {
    surround({
      provider = function(self)
        local pad = vim.g.global_symbol_padding or ' '
        local q = ' ' .. pad
        local l = ' ' .. pad
        return self.is_loclist and l .. 'Location List'
          or q .. 'Quickfix List'
      end,
    }),
    hl = { fg = 'blue' },
  },
  component.border(),
  {
    provider = function(self)
      if self.is_loclist then
        return vim.fn.getloclist(0, { title = 0 }).title
      end
      return vim.fn.getqflist({ title = 0 }).title
    end,
  },
  component.align(),
  surround({
    provider = line_count_format(),
  }),
}

-- Trouble
extensions.trouble = {
  condition = function()
    return conditions.buffer_matches({ filetype = { 'Trouble' } })
  end,
  {
    surround({ provider = ' Trouble' }),
    hl = { fg = 'blue' },
  },
  init = function(self)
    local options = require('trouble/config').options
    local words = vim.split(options.mode, '[%W]')
    for i, word in ipairs(words) do
      words[i] = word:sub(1, 1):upper() .. word:sub(2)
    end
    self.mode = table.concat(words)
  end,
  component.border(),
  {
    provider = function(self)
      return self.mode
    end,
    hl = { fg = 'green', bold = true },
  },
  component.align(),
}

-- Startify
extensions.startify = {
  condition = function()
    return conditions.buffer_matches({ filetype = { 'startify' } })
  end,
  surround({
    provider = function()
      local version = vim.version()
      return ('Welcome Neovim - %d.%d.%d'):format(
        version.major,
        version.minor,
        version.patch
      )
    end,
    hl = { fg = 'neovim_blue' },
  }),
  component.align(),
}

-- Only name and line-count
extensions.line_count = {
  static = {
    filetypes = special_filetypes,
  },
  condition = function(self)
    local types = {}
    for type, _ in pairs(self.filetypes) do
      table.insert(types, type)
    end
    return conditions.buffer_matches({ filetype = types })
  end,
  surround({
    provider = function(self)
      local ft = self.filetypes[vim.bo.filetype]
      return ft.icon .. ' ' .. ft.name
    end,
    hl = { fg = 'blue' },
  }),
  component.align(),
  surround({
    provider = line_count_format(),
  }),
}

local function statusline()
  -- Component: Mode
  local mode = {
    static = {
      names = {
        n = 'N',
        no = 'N?',
        nov = 'N?',
        noV = 'N?',
        ['no\22'] = 'N?',
        niI = 'Ni',
        niR = 'Nr',
        niV = 'Nv',
        nt = 'Nt',
        v = 'V',
        vs = 'Vs',
        V = 'V_',
        Vs = 'Vs',
        ['\22'] = '^V',
        ['\22s'] = '^V',
        s = 'S',
        S = 'S_',
        ['\19'] = '^S',
        i = 'I',
        ic = 'Ic',
        ix = 'Ix',
        R = 'R',
        Rc = 'Rc',
        Rx = 'Rx',
        Rv = 'Rv',
        Rvc = 'Rv',
        Rvx = 'Rv',
        c = 'C',
        cv = 'Ex',
        ce = 'Ex',
        r = '...',
        rm = 'M',
        ['r?'] = '?',
        ['!'] = '!',
        t = 'T',
      },
      colors = {
        n = 'blue',
        i = 'green',
        v = 'magenta',
        V = 'magenta',
        ['\22'] = 'magenta',
        c = 'orange',
        s = 'violet',
        S = 'violet',
        ['\19'] = 'violet',
        R = 'red',
        r = 'red',
        ['!'] = 'orange',
        t = 'orange',
      },
    },
    init = function(self)
      self.mode = vim.fn.mode(1)
    end,
    provider = function(self)
      return ' %2(' .. self.names[self.mode] .. '%)'
    end,
    hl = function(self)
      return { fg = self.colors[self.mode:sub(1, 1)], bold = true }
    end,
    update = {
      'ModeChanged',
      pattern = '*:*',
      callback = vim.schedule_wrap(function()
        vim.cmd('redrawstatus')
      end),
    },
  }

  -- Component: File block
  local fileblock = {
    init = function(self)
      self.bufnr = vim.api.nvim_get_current_buf()
      self.filename = vim.api.nvim_buf_get_name(self.bufnr)
    end,
    -- flags
    {
      {
        condition = function()
          return vim.bo.modifiable and not vim.bo.readonly
        end,
        provider = '󰽘',
        hl = { fg = 'soft_blue' },
      },
      {
        condition = function()
          return (not vim.bo.modifiable) or vim.bo.readonly
        end,
        provider = '',
        hl = { fg = 'soft_red' },
      },
    },
    -- buffer number
    { provider = ' %n ' },
    -- icon
    {
      init = function(self)
        self.icon, self.color = core.get_icon(self.filename)
      end,
      provider = function(self)
        return self.icon .. ' '
      end,
      hl = function(self)
        return { fg = self.color }
      end,
    },
    -- filename
    {
      provider = function(self)
        -- now, if the filename would occupy more than 1/4th of the available
        -- space, we trim the file path to its initials
        -- See Flexible Components section below for dynamic truncation
        -- if not conditions.width_percent_below(#path, 0.25) then
        return filepath(self.filename, 3, 32)
      end,
      hl = { fg = 'white' },
    },
    -- modifer
    {
      condition = function()
        return vim.bo.modified
      end,
      provider = '  ',
      hl = { fg = 'soft_red' },
    },
  }

  -- Component: Diagnostics
  local diagnostics = {
    condition = conditions.has_diagnostics,
    static = {
      icons = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
    },
    init = function(self)
      self.errors =
        #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      self.warnings =
        #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      self.info =
        #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      self.hints =
        #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
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

  -- Component: Git
  local git = {
    condition = conditions.is_git_repo,
    init = function(self)
      self.status_dict = vim.api.nvim_buf_get_var(0, 'gitsigns_status_dict')
      self.has_changed = self.status_dict.added ~= 0
        or self.status_dict.removed ~= 0
        or self.status_dict.changed ~= 0
    end,
    static = {
      icons = {
        added = '+',
        changed = '*',
        removed = '-',
      },
    },
    -- branch
    {
      provider = function(self)
        return ' ' .. self.status_dict.head
      end,
      hl = { fg = 'green', bold = true },
    },
    -- diff
    {
      {
        provider = function(self)
          local count = self.status_dict.added or 0
          return count > 0 and (' ' .. self.icons.added .. count)
        end,
        hl = 'GitSignsAdd',
      },
      {
        provider = function(self)
          local count = self.status_dict.changed or 0
          return count > 0 and (' ' .. self.icons.changed .. count)
        end,
        hl = 'GitSignsChange',
      },
      {
        provider = function(self)
          local count = self.status_dict.removed or 0
          return count > 0 and (' ' .. self.icons.removed .. count)
        end,
        hl = 'GitSignsDelete',
      },
    },
  }

  -- Component: File type
  local filetype = {
    -- type
    {
      condition = function()
        return vim.bo.filetype ~= ''
      end,
      component.border(),
      {
        provider = function()
          return vim.bo.filetype
        end,
      },
    },
    -- encoding
    {
      condition = function()
        return vim.bo.fileencoding ~= ''
      end,
      component.border(),
      {
        provider = function()
          return string.upper(vim.bo.fileencoding)
        end,
      },
    },
    -- format
    {
      component.border(),
      {
        provider = function()
          return string.upper(vim.bo.fileformat)
        end,
      },
    },
  }

  -- Component: Ruler
  local ruler = {
    provider = '' .. ' %3p%%',
    hl = { fg = 'base0' },
  }

  -- Statusline components
  local components = {
    surround(mode),
    component.space(),
    fileblock,
    component.border(),
    diagnostics,
    component.align(),
    git,
    filetype,
    component.space(),
    surround(ruler),
  }

  return {
    hl = { bg = 'base02' },
    fallthrough = false,
    extensions.vfiler,
    extensions.telescope,
    extensions.mason,
    extensions.quickfix,
    extensions.trouble,
    extensions.startify,
    extensions.line_count,
    components,
  }
end

local function winbar()
  return {
    {
      provider = ' ',
      hl = { fg = 'white' },
    },
    {
      init = function(self)
        self.bufnr = vim.api.nvim_get_current_buf()
      end,
      provider = function(self)
        local clients = vim.lsp.get_clients({ bufnr = self.bufnr })
        if #clients > 0 then
          for _, client in ipairs(clients) do
            if client.name ~= 'null-ls' then
              return client.name
            end
          end
        end
        return '[No Active Lsp]'
      end,
      hl = { fg = 'white' },
      update = { 'LspAttach', 'LspDetach' },
    },
    {
      provider = ' │ ',
      hl = 'Comment',
    },
    {
      condition = function()
        return require('nvim-navic').is_available()
      end,
      provider = function()
        return require('nvim-navic').get_location({ highlight = true })
      end,
      update = 'CursorMoved',
    },
  }
end

local function tabline()
  local vfiler_offset = {
    condition = function(self)
      local winid = vim.api.nvim_tabpage_list_wins(0)[1]
      local bufnr = vim.api.nvim_win_get_buf(winid)
      self.status = require('vfiler').status(bufnr)
      return self.status.options and self.status.options.layout == 'left'
    end,
    {
      provider = function(self)
        local padding = 3 -- icon and both ends.
        local winwidth = math.min(self.status.options.width, 128)
        local trancated, strwidth =
          truncate_path(self.status.root, winwidth - padding)
        local path = ''
        if strwidth < winwidth then
          path = trancated .. string.rep(' ', winwidth - (strwidth + padding))
        end
        return ' ' .. path .. ' '
      end,
      hl = 'TabLineAlt',
    },
    {
      provider = '',
      hl = 'TabLineAltShade',
    },
  }

  local indicator = {
    -- U+2590 ▐ Right half block, this character is right aligned so the
    -- background highlight doesn't appear in the middle
    -- alternatives:  right aligned => ▕ ▐ ,  left aligned => ▍
    provider = '▍',
    hl = function(self)
      return self.is_active and 'TabLineSepSel' or 'TabLineSep'
    end,
  }

  local tabpage_number = {
    static = {
      --charsetb = {
      --  '₀',
      --  '₁',
      --  '₂',
      --  '₃',
      --  '₄',
      --  '₅',
      --  '₆',
      --  '₇',
      --  '₈',
      --  '₉',
      --},
      charset = {
        '⁰',
        '¹',
        '²',
        '³',
        '⁴',
        '⁵',
        '⁶',
        '⁷',
        '⁸',
        '⁹',
      },
    },
    provider = function(self)
      -- NOTE: Up to 2 digits
      if self.tabnr < 10 then
        return self.charset[self.tabnr + 1]
      end
      local digit10 = math.floor(self.tabnr / 10)
      local digit1 = self.tabnr % 10
      return self.charset[digit10 + 1] .. self.charset[digit1 + 1]
    end,
  }

  local fileblock = {
    init = function(self)
      self.winid = vim.api.nvim_tabpage_get_win(self.tabpage)
      self.bufnr = vim.api.nvim_win_get_buf(self.winid)
    end,
    {
      -- file name
      static = {
        special_filetypes = special_filetypes,
      },
      provider = function(self)
        local ft = vim.api.nvim_buf_get_option(self.bufnr, 'filetype')
        local spft = self.special_filetypes[ft]
        local name
        if spft then
          name = spft.icon .. ' ' .. spft.name
        else
          local filename = vim.api.nvim_buf_get_name(self.bufnr)
          local icon, _ = core.get_icon(filename)
          name = icon .. ' ' .. filepath(filename, 0, 5)
        end
        return ('%%%sT%s'):format(self.tabnr, name)
      end,
    },
    {
      -- modifier
      condition = function(self)
        local buftype = vim.api.nvim_buf_get_option(self.bufnr, 'buftype')
        local modified = vim.api.nvim_buf_get_option(self.bufnr, 'modified')
        return modified and (#buftype == 0)
      end,
      provider = ' ●',
      hl = function(self)
        return self.is_active and 'Number' or 'TabLine'
      end,
    },
  }

  local tabpage = {
    indicator,
    tabpage_number,
    fileblock,
    component.space(),
    hl = function(self)
      return self.is_active and 'TabLineSel' or 'TabLine'
    end,
  }

  local terminal = {
    provider = '%#TablineFill#%T%#TabLine#',
  }

  local session = {
    provider = function()
      local ok, this_session = pcall(vim.api.nvim_get_vvar, 'this_session')
      if ok and #this_session > 0 then
        local session_name = vim.fn.tr(this_session, '%', '/')
        return vim.fn.fnamemodify(session_name, ':t:r') .. '  '
      end
    end,
  }

  return {
    condition = function()
      -- Skip tabline render during session loading
      return not vim.g.SessionLoad
    end,
    vfiler_offset,
    utils.make_tablist(tabpage),
    terminal,
    session,
  }
end

function M.setup()
  local config = {
    statusline = statusline(),
    tabline = tabline(),
    opts = {
      --colors = core.get_colors(),
      colors = {
        base03    = utils.get_highlight('SolarizedColorBase03').fg,
        base02    = utils.get_highlight('SolarizedColorBase02').fg,
        base01    = utils.get_highlight('SolarizedColorBase01').fg,
        base00    = utils.get_highlight('SolarizedColorBase00').fg,
        base0     = utils.get_highlight('SolarizedColorBase0').fg,
        base1     = utils.get_highlight('SolarizedColorBase1').fg,
        base2     = utils.get_highlight('SolarizedColorBase2').fg,
        base3     = utils.get_highlight('SolarizedColorBase3').fg,
        yellow    = utils.get_highlight('SolarizedColorYellow').fg,
        orange    = utils.get_highlight('SolarizedColorOrange').fg,
        red       = utils.get_highlight('SolarizedColorRed').fg,
        magenta   = utils.get_highlight('SolarizedColorMagenta').fg,
        violet    = utils.get_highlight('SolarizedColorViolet').fg,
        blue      = utils.get_highlight('SolarizedColorBlue').fg,
        cyan      = utils.get_highlight('SolarizedColorCyan').fg,
        green     = utils.get_highlight('SolarizedColorGreen').fg,
        white     = utils.get_highlight('SolarizedColorWhite').fg,
        soft_blue = utils.get_highlight('SolarizedColorSoftBlue').fg,
        soft_red  = utils.get_highlight('SolarizedColorSoftRed').fg,
        russian_blue = utils.get_highlight('SolarizedColorRussianBlue').fg,
        neovim_blue = '#3791D4',
      },
      disable_winbar_cb = function(args)
        return conditions.buffer_matches({
          buftype = { 'nofile', 'prompt', 'help', 'quickfile' },
          filetype = { 'vfiler', 'startify' },
        }, args.buf)
      end,
    },
  }
  if vim.fn.has('nvim-0.8') == 1 then
    config.winbar = winbar()
  end
  require('heirline').setup(config)
end

return M
