-- plugin: nvim-treesitter
-- see: https://github.com/nvim-treesitter/nvim-treesitter

local M = {}

-- Setup treesitter
function M.setup()
  local parset_configs = require('nvim-treesitter/parsers').get_parser_configs()
  parset_configs.http = {
    filetype = 'http',
    install_info = {
      url = 'https://github.com/rest-nvim/tree-sitter-http',
      files = {'src/parser.c'},
      branch = 'main',
    },
  }

  require('nvim-treesitter.configs').setup({
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },

    --indent = {
    --  enable = true,
    --},

    refactor = {
      highlight_definitions = {enable = true},
      highlight_current_scope = {enable = true},
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
    }
  })
end

return M
