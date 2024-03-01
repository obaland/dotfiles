-- plugin: telescope.nvim
-- see: https://github.com/nvim-telescope/telescope.nvim

local core = require('core')

local M = {}

local grep_arguments
if vim.fn.executable('rg') == 1 then
  grep_arguments = {
    'rg',
    '--column',
    '--color=never',
    '--smart-case',
    '--line-number',
    '--no-heading',
    '--with-filename',
  }
else
  grep_arguments = {
    'git',
    'grep',
    '--column',
    '--color=auto',
    '--ignore-case',
    '--line-number',
    '--no-heading',
    '--recursive',
    '--untracked',
  }
end

local function grep(cwd, default_text)
  require('telescope/builtin').live_grep({
    cwd = cwd,
    default_text = default_text,
  })
end

local function find_files(cwd)
  require('telescope/builtin').find_files({
    cwd = cwd,
  })
end

-- Custom actions

local custom_actions = {}

function custom_actions.page_up(bufnr)
  require('telescope/actions/set').shift_selection(bufnr, -5)
end

function custom_actions.page_down(bufnr)
  require('telescope/actions/set').shift_selection(bufnr, 5)
end

-- Custom pickers

function M.grep()
  grep(core.project_root(0))
end

function M.grep_string()
  grep(core.project_root(0), vim.fn.expand('<cword>'))
end

function M.grep_buffer()
  grep(vim.fn.expand('%:p:h'))
end

function M.find_files()
  find_files(core.project_root(0))
end

function M.find_files_buffer()
  find_files(vim.fn.expand('%:p:h'))
end

-- Custom window-sizes

local function horizontal_preview_width(_, cols, _)
  if cols > 200 then
    return math.floor(cols * 0.7)
  else
    return math.floor(cols * 0.6)
  end
end

local function width_for_nopreview(_, cols, _)
  if cols > 200 then
    return math.floor(cols * 0.5)
  elseif cols > 110 then
    return math.floor(cols * 0.6)
  else
    return math.floor(cols * 0.75)
  end
end

local function height_dropdown_nopreview(_, _, rows)
  return math.floor(rows * 0.7)
end

-- Enable indent-guides in telescope preview
vim.cmd([[
	augroup telescope_events
		autocmd!
		autocmd User TelescopePreviewerLoaded setlocal wrap list number
	augroup END
]])

-- Setup
function M.setup()
  local actions = require('telescope.actions')
  local transform_mod = require('telescope/actions/mt').transform_mod

  -- Transform to Telescope proper action
  custom_actions = transform_mod(custom_actions)

  local telescope = require('telescope')
  telescope.setup({
    defaults = {
      vimgrep_arguments = grep_arguments,
      sorting_strategy = 'ascending',
      scroll_strategy = 'cycle',
      cache_picker = {
        num_pickers = 3,
        limit_entries = 300,
      },

      prompt_prefix = '   ',
      selection_caret = '▍ ',
      multi_icon = ' ',

      file_ignore_patterns = { 'node_modules' },
      set_env = { COLORTERM = 'truecolor' },

      -- Flex layout swaps between horizontal and vertical strategies
      -- based on the window width. See :h telescope.layout
      layout_strategy = 'flex',
      layout_config = {
        width = 0.9,
        height = 0.85,
        prompt_position = 'top',

        horizontal = {
          -- width_padding = 0.1,
          -- height_padding = 0.1,
          -- preview_cutoff = 60,
          preview_width = horizontal_preview_width,
        },
        vertical = {
          -- width_padding = 0.05,
          -- height_padding = 1,
          width = 0.75,
          height = 0.85,
          preview_height = 0.4,
          mirror = true,
        },
        flex = {
          -- change to horizontal after 120 cols
          flip_columns = 120,
        },
      },

      mappings = {
        i = {
          ['<Tab>'] = actions.move_selection_next,
          ['<S-Tab'] = actions.move_selection_previous,
          ['<C-j>'] = actions.move_selection_next,
          ['<C-k>'] = actions.move_selection_previous,

          ['<C-b>'] = custom_actions.page_up,
          ['<C-f>'] = custom_actions.page_down,

          ['<Down>'] = actions.cycle_history_next,
          ['<Up>'] = actions.cycle_history_prev,
          ['<C-n>'] = actions.cycle_history_next,
          ['<C-p>'] = actions.cycle_history_prev,

          ['<C-u>'] = actions.preview_scrolling_up,
          ['<C-d>'] = actions.preview_scrolling_down,
        },
        n = {
          ['q'] = actions.close,
          ['<Esc>'] = actions.close,

          ['<Tab>'] = actions.move_selection_next,
          ['<S-Tab'] = actions.move_selection_previous,

          ['<C-b>'] = custom_actions.page_up,
          ['<C-f>'] = custom_actions.page_down,

          ['<C-n>'] = actions.cycle_history_next,
          ['<C-p>'] = actions.cycle_history_prev,

          ['<C-u>'] = actions.preview_scrolling_up,
          ['<C-d>'] = actions.preview_scrolling_down,

          ['*'] = actions.toggle_all,
          ['u'] = actions.drop_all,
          ['<Space>'] = actions.toggle_selection
            + actions.move_selection_next,
          ['<S-Space>'] = actions.toggle_selection
            + actions.move_selection_next,

          ['gg'] = actions.move_to_top,
          ['G'] = actions.move_to_bottom,

          ['s'] = actions.select_horizontal,
          ['v'] = actions.select_vertical,
          ['t'] = actions.select_tab,
          ['l'] = actions.select_default,
        },
      },
    },
    pickers = {
      buffers = {
        theme = 'dropdown',
        previewr = false,
        sort_lastused = true,
        sort_mru = true,
        show_all_buffers = true,
        ignore_current_buffer = true,
        path_display = { truncate = 3 },
        layout_config = {
          width = width_for_nopreview,
          height = height_dropdown_nopreview,
        },
        mappings = {
          n = {
            ['dd'] = actions.delete_buffer,
          },
        },
      },
      find_files = {
        theme = 'dropdown',
        previewer = false,
        layout_config = {
          width = width_for_nopreview,
          height = height_dropdown_nopreview,
        },
        find_command = {
          'rg',
          '--smart-case',
          '--hidden',
          '--no-ignore-vcs',
          '--glob',
          '!.git',
          '--files',
        },
      },
      live_grep = {
        dynamic_preview_title = true,
      },
      colorscheme = {
        enable_preview = true,
        leyout_config = { width = 0.45, height = 0.8 },
      },
      hightlights = {
        layout_strategy = 'horizontal',
        layout_config = { preview_width = 0.8 },
      },
    },
    extensions = {
      ['ui-select'] = {
        require('telescope/themes').get_cursor({
          layout_config = { width = 0.35, height = 0.35 },
        }),
      },
      aerial = {
        -- Display symbols as <root>.<parent>.<symbol>
        show_nesting = {
          ['_'] = false,
        },
      },
    },
  })
end

return M
