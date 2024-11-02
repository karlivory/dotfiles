---@type LazySpec
return {
  --###################### DISABLED PLUGINS #########################
  { "rcarriga/nvim-notify", enabled = true },
  { "goolord/alpha-nvim", enabled = false },
  { "max397574/better-escape.nvim", enabled = false },
  { "stevearc/resession.nvim", enabled = false },
  ------------------------------------------------------------
  --#################################################################
  --####################### CUSTOM PLUGINS ##########################
  -- TODO: install these plugins:
  -- syntax tree surfer
  -- undotree
  -- treesj
  { "famiu/bufdelete.nvim", lazy = false },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = true,
  },
  ------------------------------------------------------------
}
