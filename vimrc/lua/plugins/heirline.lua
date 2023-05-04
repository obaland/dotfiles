local conditions = require('heirline/conditions')
local core = require('core')
local utils = require('heirline/utils')
local vfiler = require('vfiler')

local M = {}

local function line_count_format()
  return '%7(%l/%3L%)'
end

local function filepath(filename)
  local path = vim.fn.fnamemodify(filename, ':.')
  if path == '' then
    return '[No Name]'
  end
  -- now, if the filename would occupy more than 1/4th of the available
  -- space, we trim the file path to its initials
  -- See Flexible Components section below for dynamic truncation
  if not conditions.width_percent_below(#path, 0.25) then
    path = vim.fn.pathshorten(path)
  end
  return core.normalize_path(path)
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
        s = 'purple',
        S = 'purple',
        ['\19'] = 'purple',
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
      self.filename = vim.api.nvim_buf_get_name(0)
    end,
    -- flags
    {
      {
        condition = function()
          return vim.bo.modifiable and not vim.bo.readonly
        end,
        provider = '',
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
        return filepath(self.filename)
      end,
      hl = { fg = 'grayish_yellow' },
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
      self.status_dict = vim.b.gitsigns_status_dict
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
  }

  -- Component: Ruler
  local ruler = {
    provider = line_count_format() .. ':%2c %3p%%',
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

  -- Extension: vfiler
  local extension_vfiler = {
    condition = function()
      return conditions.buffer_matches({ filetype = { 'vfiler' } })
    end,
    init = function(self)
      self.status = vfiler.status()
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
        return self.status.current_item.path
      end,
      hl = { fg = 'grayish_yellow' },
    },
    component.align(),
  }

  -- Extension: Quickfix
  local extension_quickfix = {
    condition = function()
      return conditions.buffer_matches({ filetype = { 'qf' } })
    end,
    init = function(self)
      self.is_loclist = vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0
    end,
    {
      provider = function(self)
        local pad = vim.g.global_symbol_padding or ' '
        local q = ' ' .. pad
        local l = ' ' .. pad
        return self.is_loclist and l .. 'Location List'
          or q .. 'Quickfix List'
      end,
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

  -- Extension: Only name and line-count
  local extension_line_count = {
    static = {
      filetypes = {
        undotree = { icon = '', name = 'undotree' },
        TelescopePrompt = { icon = '', name = 'Telescope' },
        Trouble = { icon = '', name = 'Trouble' },
        DiffviewFiles = { icon = '', name = 'DiffviewFiles' },
        Outline = { icon = '', name = 'Outline' },
        NeogitStatus = { icon = '', name = 'NeogitStatus' },
        ['mason.nvim'] = { icon = '', name = 'Mason' },
        spectre_panel = { icon = '', name = 'Spectre' },
      },
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

  return {
    hl = { bg = 'base02' },
    fallthrough = false,
    extension_vfiler,
    extension_quickfix,
    extension_line_count,
    components,
  }
end

local function winbar()
  return {
    {
      init = function(self)
        local bufnr = vim.api.nvim_get_current_buf()
        self.clients = vim.lsp.get_active_clients({ bufnr = bufnr })
      end,
      provider = function(self)
        local name
        if #self.clients == 0 then
          name = '[No Active Lsp]'
        else
          name = self.clients[1].name
        end
        return ' ' .. name
      end,
      hl = 'WinbarLspClientName',
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

function M.setup()
  require('heirline').setup({
    statusline = statusline(),
    winbar = winbar(),
    opts = {
      colors = core.get_colors(),
      --disable_winbar_cb = function(args)
      --  local clients = vim.lsp.get_active_clients({ bufnr = args.buf })
      --  return #clients == 0 or clients[1].name == 'null-ls'
      --end,
    },
  })
end

return M
