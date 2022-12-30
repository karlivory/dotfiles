-- install new plugins (packer syntax)
return {
  ["rcarriga/nvim-notify"] = { disable = true },
  {
    "kylechui/nvim-surround",
    config =
    function()
      require("nvim-surround").setup()
    end,
    tag = "*"
  },
  ["simrat39/rust-tools.nvim"] = {
    after = { "mason-lspconfig.nvim" },
    ft = { "rust" },
    config = function() require("rust-tools").setup(require "user.plugins.rust-tools") end,
  },
}
