return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.rust" },
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
}
