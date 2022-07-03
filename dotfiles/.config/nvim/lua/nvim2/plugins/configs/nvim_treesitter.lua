local treesitter_config = require('nvim-treesitter.configs')

treesitter_config.setup({
  highlight = {
    enable = true,
  },

  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      },
    },
    swap = {
      enable = true,
      -- will this ever be useful?
      swap_next = {
        ["<leader>sa"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>sA"] = "@parameter.inner",
      },
    },
  },
  rainbow = {
    enable = true,
    extended_mode = false,
  },

  autotag = { enable = true },

  autopairs = { enable = true },
})

