local present, impatient = pcall(require, "impatient")

-- color scheme (TODO: load this only if gruvbox is installed)
vim.opt.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

if present then
   impatient.enable_profile()
end

require('nvim')

