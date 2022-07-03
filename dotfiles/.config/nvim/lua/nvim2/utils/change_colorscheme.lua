return function(colorscheme)
  vim.cmd(string.format([[colorscheme %s]], colorscheme))
  require("nvim2.ui.highlights").load_highlights()
end
