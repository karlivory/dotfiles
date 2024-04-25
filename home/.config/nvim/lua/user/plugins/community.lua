return {
  "AstroNvim/astrocommunity",
  -- { import = "astrocommunity.pack.ansible" }, # annoying error messages
  -- { import = "astrocommunity.pack.helm" }, # annoying error messages
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.vue" },
  {
    -- further customize the options set by the community
    "rust-tools.nvim",
    opts = {
      tools = {
        inlay_hints = {
          auto = false
        }
      }
    },
  },
  { import = "astrocommunity.editing-support.zen-mode-nvim" },
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        backdrop = 0.95,
        width = 120,
        height = 1,
        options = {
          signcolumn = "no",
          number = true,
          relativenumber = true,
        },
      },
    },
  },
  { import = "astrocommunity.pack.python-ruff" },
}
