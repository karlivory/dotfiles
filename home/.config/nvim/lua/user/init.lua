local config = {
  lsp = {
    skip_setup =
    {
      "rust_analyzer", -- handled by rust-tools.nvim
      "jdtls"          -- handled by nvim-jdtls
    },
  },
  polish = function() require "user.autocmds" end,
}

return config
