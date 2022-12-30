-- install new plugins (packer syntax)
return {
  -------------------- DISABLED PLUGINS ----------------------
  ["rcarriga/nvim-notify"] = { disable = true },
  ["goolord/alpha-nvim"]   = { disable = true },
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
  {
    "simrat39/rust-tools.nvim",
    config = function() require("rust-tools").setup(require "user.plugins.rust-tools") end,
    after = { "mason-lspconfig.nvim" },
    ft = { "rust" },
  },
  {
    "Saecki/crates.nvim",
    after = "nvim-cmp",
    config = function()
      require("crates").setup()
      astronvim.add_cmp_source { name = "crates", priority = 1100 }

      -- Crates mappings:
      local map = vim.api.nvim_set_keymap
      map("n", "<leader>Ct", ":lua require('crates').toggle()<cr>", { desc = "Toggle extra crates.io information" })
      map("n", "<leader>Cr", ":lua require('crates').reload()<cr>", { desc = "Reload information from crates.io" })
      map("n", "<leader>CU", ":lua require('crates').upgrade_crate()<cr>", { desc = "Upgrade a crate" })
      map("v", "<leader>CU", ":lua require('crates').upgrade_crates()<cr>", { desc = "Upgrade selected crates" })
      map("n", "<leader>CA", ":lua require('crates').upgrade_all_crates()<cr>", { desc = "Upgrade all crates" })
    end,
  },
  {
    "folke/zen-mode.nvim",
    cmd = { "ZenMode" },
    config = function() require("user.plugins.zen-mode").config() end,
  },
  ------------------------------------------------------------
}
