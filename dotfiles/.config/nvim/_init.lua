local present, impatient = pcall(require, "impatient")

local ok, _ = pcall(require, "gruvbox")
if ok then
  vim.opt.background = "dark" -- or "light" for light mode
	vim.cmd([[colorscheme gruvbox]])
end

if present then
   impatient.enable_profile()
end

require('nvim')

