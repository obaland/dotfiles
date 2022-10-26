" telescope.rc.vim
"=============================================================================

lua <<EOF

local builtin = require('telescope.builtin')

local function get_git_root()
  local path = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  if (not path or #path == 0) or path:match('^fatal') then
    return nil
  end
  return path
end

local function get_workdir()
  local path = get_git_root()
  if path then
    return path
  end
  return vim.fn.getcwd()
end

local function find_files(cwd)
  builtin.find_files({cwd = cwd})
end

local function grep(cwd)
  builtin.live_grep({cwd = cwd})
end

local function grep_string(cwd)
  builtin.grep_string({cwd = cwd})
end

-- Setup
local actions = require('telescope.actions')
require('telescope').setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--column',
      '--color=never',
      '--smart-case',
      '--line-number',
      '--no-heading',
      '--with-filename',
    },

    mappings = {
      n = {
        ['q'] = actions.close
      },
      i = {
        ['<ESC>'] = actions.close,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      }
    }
  }
}

-- Keymapping
vim.keymap.set('n', '<Leader>a', builtin.autocommands, {})

vim.keymap.set('n', '<Leader>bb', builtin.buffers, {})

vim.keymap.set('n', '<Leader>gg', function() grep(get_workdir()) end, {})
vim.keymap.set('n', '<Leader>gw', function() grep_string(get_workdir()) end, {})
vim.keymap.set('n', '<Leader>gb', function() grep(vim.fn.expand('%:p:h')) end, {})

vim.keymap.set('n', '<Leader>ff', function() find_files(get_workdir()) end, {})
vim.keymap.set('n', '<Leader>fb', function() find_files(vim.fn.expand('%:p:h')) end, {})
vim.keymap.set('n', '<Leader>fg', builtin.git_files, {})
vim.keymap.set('n', '<Leader>fm', builtin.oldfiles, {})

vim.keymap.set('n', '<Leader>hl', builtin.highlights, {})

vim.keymap.set('n', '<Leader>r', builtin.registers, {})

vim.keymap.set('n', '<Leader>mm', builtin.keymaps, {})
vim.keymap.set('n', '<Leader>mn', function() builtin.keymaps({modes = {'n'}}) end, {})
vim.keymap.set('n', '<Leader>mx', function() builtin.keymaps({modes = {'x'}}) end, {})
vim.keymap.set('n', '<Leader>mo', function() builtin.keymaps({modes = {'o'}}) end, {})
vim.keymap.set('n', '<Leader>mi', function() builtin.keymaps({modes = {'i'}}) end, {})

EOF
