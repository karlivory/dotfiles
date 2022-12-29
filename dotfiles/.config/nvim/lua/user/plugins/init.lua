-- install new plugins (packer syntax)
return {
  {
    "kylechui/nvim-surround",
    config =
    function()
      require("nvim-surround").setup()
    end,
    tag = "*"
  },
  ["mfussenegger/nvim-jdtls"] = { module = "jdtls" }, -- load jdtls on module
  ["simrat39/rust-tools.nvim"] = {
    after = { "mason-lspconfig.nvim" },
    ft = { "rust" },
    config = function() require("rust-tools").setup(require "user.plugins.rust-tools") end,
  },
}
