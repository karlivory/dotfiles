local kmap = require("nvim2.temp.utils").kmap

-- local options = { noremap = true }
-- local cmd_options = { noremap = true, silent = true }

vim.g.mapleader = ' '

-- INSERT-MODE
kmap("i", ",",              ",<C-g>u", "undo breakpoints")
kmap("i", ".",              ".<C-g>u", "undo breakpoints")
kmap("i", "!",              "!<C-g>u", "undo breakpoints")
kmap("i", "?",              "?<C-g>u", "undo breakpoints")
kmap("i", "<C-s>",          "<cmd>w<CR>", "save file")

-- NORMAL-MODE
kmap("n", "<C-s>",          "<cmd> w <CR>", "﬚  save file")
kmap("n", "<ESC>",          "<cmd> noh <CR>", "  no highlight")
kmap("n", "<C-h>",          "C-w>h", " window left")
kmap("n", "<C-l>",          "C-w>l", " window right")
kmap("n", "<C-j>",          "C-w>j", " window down")
kmap("n", "<C-k>",          "C-w>k", " window up")
kmap("n", "<C-c>",          "<cmd> %y+ <CR>", "  copy whole file to clipboard")
kmap("n", "<C-q>",          "<cmd>lua require('nvim2.plugins.custom.tmux_sessionizer').find()<cr>", "tmux-sessionizer")
kmap("n", "<C-TAB>",        "<cmd> BufferLineCycleNext <CR>", "  cycle next buffer")
kmap("n", "<C-S-Tab>",      "<cmd> BufferLineCyclePrev <CR>", "  cycle prev buffer")
kmap("n", "<C-e>",          "<cmd> NvimTreeToggle <CR>", "   toggle nvimtree")
kmap("n", "gD",             "<cmd>lua vim.lsp.buf.declaration()<cr>")
kmap("n", "gd",             "<cmd>lua vim.lsp.buf.definition()<cr>")

-- TELESCOPE
kmap("n", "<C-f>",          "<cmd> Telescope find_files hidden=true<CR>", "  find files")
kmap("n", "<leader>cm",     "<cmd> Telescope git_commits <CR>", "   git commits")
kmap("n", "<leader>fa",     "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "  find all")
kmap("n", "<leader>fb",     "<cmd> Telescope buffers <CR>", "  find buffers")
kmap("n", "<leader>fh",     "<cmd> Telescope help_tags <CR>", "  help page")
kmap("n", "<leader>fo",     "<cmd> Telescope oldfiles <CR>", "   find oldfiles")
kmap("n", "<leader>fw",     "<cmd> Telescope live_grep<CR>", "   live grep")
kmap("n", "<leader>gt",     "<cmd> Telescope git_status <CR>", "  git status")
kmap("n", "<leader>pt",     "<cmd> Telescope terms <CR>", "   pick hidden term")
kmap("n", "<leader>tk",     "<cmd> Telescope keymaps <CR>", "   show keys")

-- LSP
kmap("n", "<leader>D",      "<cmd>lua vim.lsp.buf.type_definition()<cr>")
kmap("n", "<leader>ca",     "<cmd>lua vim.lsp.buf.code_action()<cr>")
kmap("n", "<leader>f",      "<cmd>lua vim.diagnostic.open_float()<cr>")
kmap("n", "<leader>fm",     "<cmd>lua vim.lsp.buf.formatting()<cr>")
kmap("n", "<leader>ls",     "<cmd>lua vim.lsp.buf.signature_help()<cr>")
kmap("n", "<leader>q",      "<cmd>lua vim.diagnostic.setloclist()<cr>")
kmap("n", "<leader>rn",     "<cmd>lua require('ui.renamer').open()<cr>")
kmap("n", "<leader>wa",     "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>")
kmap("n", "<leader>wl",     "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>")
kmap("n", "<leader>wr",     "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>")
kmap("n", "K",              "<cmd>lua vim.lsp.buf.hover()<cr>")
kmap("n", "[d",             "<cmd>lua vim.diagnostic.goto_prev()<cr>")
kmap("n", "d]",             "<cmd>lua vim.diagnostic.goto_next()<cr>")
kmap("n", "gi",             "<cmd>lua vim.lsp.buf.implementation()<cr>")
kmap("n", "gr",             "<cmd>lua vim.lsp.buf.references()<cr>")
kmap('n', '<Leader>R',      '<cmd>lua require("nvim2.utils").reload_config()<cr>', "Reload nvim config")
kmap('n', '<Leader>T',      "<cmd><cr>", "Change colorscheme")
kmap("n", "<leader>T",      "<cmd>lua require('nvim2.plugins.custom.colorscheme_picker').find()<cr>", "Pick colorscheme")
