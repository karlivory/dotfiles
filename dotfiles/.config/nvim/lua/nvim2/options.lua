local option = vim.opt
local g = vim.g
local settings = require("nvim2.settings")

vim.opt.background = "dark" -- or "light" for light mode
g.nvchad_theme = settings.ui.theme
g.transparency = settings.ui.transparency
-- g.theme_switcher_loaded = false

-- NOTE: Global

option.laststatus = 3 -- single statusline for all windows
option.smartcase = true
option.updatetime = 300
option.splitright = true
option.showmatch = true
option.showmode = false
option.showtabline = 2
option.scrolloff = 18
option.termguicolors = true
option.shortmess = 'atOIc'
option.timeoutlen = 400
-- option.completeopt = 'menuone,noselect'
-- option.shortmess:append({ c = true, F = true, T = true })
option.clipboard:append({ 'unnamedplus' })
option.fillchars = 'eob: '
option.statusline = "%!v:lua.require('nvim2.ui.statusline').run()" 
option.mouse = "a"

-- NOTE: Local to window
option.number = true
option.relativenumber = true
option.cursorline = true
option.signcolumn = 'yes'
option.list = true
-- HACK: indent-blankline https://github.com/lukas-reineke/indent-blankline.nvim/issues/59#issuecomment-806398054
option.colorcolumn = '99999'

-- NOTE: Local to buffer
option.shiftwidth = 4
option.tabstop = 4
option.softtabstop = 4
option.expandtab = true
option.smartindent = true
option.swapfile = false
option.ignorecase = true
option.undofile = true
-- option.fileformat = 'unix'
