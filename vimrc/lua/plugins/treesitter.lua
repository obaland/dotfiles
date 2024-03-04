-- plugin: nvim-treesitter
-- see: https://github.com/nvim-treesitter/nvim-treesitter

local M = {}

-- Setup treesitter
function M.setup()
  -- Parser install directory settings.
  -- NOTE: Priority over `query` to be installed in neovim.
  local install_dir = vim.fn.stdpath('data') .. '/treesitter'
  vim.opt.runtimepath:prepend(install_dir)

  require('nvim-treesitter.configs').setup({
    parser_install_dir = install_dir,

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },

    --indent = {
    --  enable = true,
    --},

    refactor = {
      highlight_definitions = { enable = true },
      highlight_current_scope = { enable = true },
    },

    -- See: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    textobjects = {
      select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
    },

    -- See: https://github.com/JoosepAlviste/nvim-ts-context-commentstring
    context_commentstring = {
      enable = true,
      -- Let other plugins (kommentary) call 'update_commentstring()' manually.
      enable_autocmd = false,
    },

    -- See: https://github.com/windwp/nvim-ts-autotag
    autotag = {
      enable = true,
      filetypes = {
        'html',
        'javascript',
        'javascriptreact',
        'typescriptreact',
        'svelte',
        'vue',
      },
    },

    -- See: https://github.com/nvim-treesitter/playground
    playground = {
      enable = true,
      disable = {},
      updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      persist_queries = false, -- Whether the query persists across vim sessions
      keybindings = {
        toggle_query_editor = 'o',
        toggle_hl_groups = 'i',
        toggle_injected_languages = 't',
        toggle_anonymous_nodes = 'a',
        toggle_language_display = 'I',
        focus_language = 'f',
        unfocus_language = 'F',
        update = 'R',
        goto_node = '<cr>',
        show_help = '?',
      },
    },
  })
end

return M
