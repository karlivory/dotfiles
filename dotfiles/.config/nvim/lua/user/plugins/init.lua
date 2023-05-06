return {
  -------------------- DISABLED PLUGINS ----------------------
  { "rcarriga/nvim-notify",         enabled = true },
  { "goolord/alpha-nvim",           enabled = false },
  { "max397574/better-escape.nvim", enabled = false },
  ------------------------------------------------------------
  --------------------- CUSTOM PLUGINS -----------------------
  -- TODO: install these plugins:
  -- syntax tree surfer
  -- undotree
  -- treesj
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = true
  },
  -- {
  --   "folke/zen-mode.nvim",
  --   cmd = { "ZenMode" },
  --   config = function() require("user.plugins.zen-mode").config() end,
  -- },
  -- TODO: textobjects don't work, fix this
  -- might help: https://old.reddit.com/r/neovim/comments/113un5z/problem_with_treesitter_textobjects/
  -- {
  --   "nvim-treesitter/nvim-treesitter-textobjects",
  --   config = function()
  --     require("nvim-treesitter.configs").setup({
  --       textobjects = {
  --         select = {
  --           enable = true,
  --           -- Automatically jump forward to textobj, similar to targets.vim
  --           lookahead = true,
  --           keymaps = {
  --             -- You can use the capture groups defined in textobjects.scm
  --             ["af"] = "@function.outer",
  --             ["if"] = "@function.inner",
  --             ["ac"] = "@class.outer",
  --             ["ic"] = "@class.inner",
  --           },
  --         },
  --       },
  --     })
  --   end
  -- },
  ------------------------------------------------------------
}
