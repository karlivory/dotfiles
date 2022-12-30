-- install new plugins (packer syntax)
return {
  -------------------- DISABLED PLUGINS ----------------------
  ["rcarriga/nvim-notify"]     = { disable = true },
  ["goolord/alpha-nvim"]       = { disable = true },
  ------------------------------------------------------------
  --------------------- CUSTOM PLUGINS -----------------------
  -- TODO: install these plugins:
  -- syntax tree surfer
  -- undotree
  -- zen-mode
  {
    "kylechui/nvim-surround",
    config = function() require("nvim-surround").setup() end,
    tag = "*"
  },
  ["simrat39/rust-tools.nvim"] = {
    config = function() require("rust-tools").setup(require "user.plugins.rust-tools") end,
    after = { "mason-lspconfig.nvim" },
    ft = { "rust" },
  },
  ------------------------------------------------------------
}
