---@type LazySpec
return {
  --###################### DISABLED PLUGINS #########################
  { "max397574/better-escape.nvim", enabled = false },
  { "stevearc/resession.nvim", enabled = false },
  { "akinsho/toggleterm.nvim", enabled = false },
  ------------------------------------------------------------
  --#################################################################
  --####################### CUSTOM PLUGINS ##########################
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = true,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      -- bigfile = { enabled = true },
      dashboard = { enabled = false },
      -- explorer = { enabled = true },
      -- indent = { enabled = true },
      -- input = { enabled = true },
      picker = { enabled = true },
      -- notifier = { enabled = true },
      -- quickfile = { enabled = true },
      -- scope = { enabled = true },
      -- scroll = { enabled = true },
      -- statuscolumn = { enabled = true },
      -- words = { enabled = true },
    },
  },
  ------------------------------------------------------------
}
