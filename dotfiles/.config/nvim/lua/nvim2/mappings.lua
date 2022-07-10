local kmap = require("nvim2.utils").kmap

-- local options = { noremap = true }
-- local cmd_options = { noremap = true, silent = true }

local default_opts = { silent = true, noremap = true }
vim.g.mapleader = ' '

-- INSERT-MODE
kmap("i", "<c-h>",          "<c-w>", "Delete previous word")
kmap("i", ",",              ",<C-g>u", "undo breakpoints")
kmap("i", ".",              ".<c-g>u", "undo breakpoints")
kmap("i", "!",              "!<c-g>u", "undo breakpoints")
kmap("i", "?",              "?<c-g>u", "undo breakpoints")
kmap("i", "<c-s>",          "<cmd>write<CR>", "save file")
kmap("i", "<c-y>",          "<cmd>lua require('nvim2.utils').better_escape()<CR>", "  no highlight")

-- increment/decrement
kmap("n", "ga",             "<c-a>", "increment")
kmap("n", "gx",             "<c-x>", "decrement ([L]ower)")
kmap("v", "ga",             "g<c-a>", "increment (multi)")
kmap("v", "gx",             "g<c-x>", "increment (multi)")

-- NORMAL-MODE
kmap("n", "<c-s>",          "<cmd>lua require('nvim2.utils').save()<CR>", "save file")
-- kmap("n", "<c-s>",          "<cmd> w <CR>", "﬚  save file")
kmap("n", "<c-q>",          "<cmd>bd<cr>", "close buffer")
kmap("n", "<ESC>",          "<cmd>noh<CR>", "  no highlight")
kmap("n", "<c-y>",          "<cmd>lua require('nvim2.utils').better_escape()<CR>", "  no highlight")
kmap("n", "<c-h>",          "<C-w>h", " window left")
kmap("n", "<c-l>",          "<C-w>l", " window right")
kmap("n", "<c-j>",          "<C-w>j", " window down")
kmap("n", "<c-k>",          "<C-w>k", " window up")
kmap("n", "<c-c>",          "<cmd> %y+ <CR>", "  copy whole file to clipboard")
kmap("n", "<c-x>",          "<cmd>lua require('nvim2.plugins.custom.tmux_sessionizer').find()<cr>", "tmux-sessionizer")
kmap("n", "<c-TAB>",        "<cmd> BufferLineCycleNext <CR>", "  cycle next buffer")
kmap("n", "<c-S-Tab>",      "<cmd> BufferLineCyclePrev <CR>", "  cycle prev buffer")
kmap("n", "<c-e>",          "<cmd> NeoTreeRevealToggle <CR>", "   toggle neotree")
kmap("n", "gs",             "<cmd>lua require('nvim2.utils').toggle_boolean()<CR>", "toggle boolean")

-- TELESCOPE
kmap("n", "<c-f>",          "<cmd> Telescope find_files hidden=true<CR>", "  find files")
kmap("n", "<leader>cm",     "<cmd> Telescope git_commits <CR>", "   git commits")
kmap("n", "<leader>fh",     "<cmd> Telescope help_tags <CR>", "  help page")
kmap("n", "<leader>fo",     "<cmd> Telescope buffers <CR>", " find open buffers")
kmap("n", "<leader>fj",     "<cmd> Telescope jumplist <CR>")
kmap("n", "<leader>ft",     "<cmd> Telescope treesitter <CR>")
kmap("n", "<leader>fw",     "<cmd> Telescope live_grep<CR>", "   live grep")
kmap("n", "<leader>fg",     "<cmd> Telescope git_status <CR>", "  git status")
kmap("n", "<leader>fk",     "<cmd> Telescope keymaps <CR>", " find in keymaps")
kmap("n", "<leader>fq",     "<cmd> Telescope quickfix <CR>")
kmap("n", "<leader>fQ",     "<cmd> Telescope quickfixhistory <CR>")
kmap("n", "<leader>fd",     "<cmd> Telescope diagnostics bufnr=0 <CR>", "diagnostics in current buffer")
kmap("n", "<leader>fD",     "<cmd> Telescope diagnostics <CR>", "diagnostics (hint: press <c-l>)")

-- LSP
-- kmap("n", "<leader>D",      "<cmd>lua vim.lsp.buf.type_definition()<cr>")
-- kmap("n", "<leader>ca",     "<cmd>lua vim.lsp.buf.code_action()<cr>")
-- kmap("n", "<leader>fm",     "<cmd>lua vim.lsp.buf.formatting()<cr>")
-- kmap("n", "<leader>ls",     "<cmd>lua vim.lsp.buf.signature_help()<cr>")
-- kmap("n", "<leader>q",      "<cmd>lua vim.diagnostic.setloclist()<cr>")
-- kmap("n", "<leader>wa",     "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>")
kmap("n", "gD",             "<cmd>lua vim.lsp.buf.declaration()<cr>")
kmap("n", "gd",             "<cmd>lua vim.lsp.buf.definition()<cr>")
kmap("n", "<leader>lwl",     "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>")
kmap("n", "<leader>lwr",     "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>")
kmap("n", "[d",             "<cmd>lua vim.diagnostic.goto_prev()<cr>")
kmap("n", "]d",             "<cmd>lua vim.diagnostic.goto_next()<cr>")
-- kmap("n", "gi",             "<cmd>lua vim.lsp.buf.implementation()<cr>")
kmap("n", "gr",             "<cmd>lua vim.lsp.buf.references()<cr>")

-- DAP
kmap("n", "<leader>dt",     "<cmd>lua require('dapui').toggle()<cr>", "Toggle dapui")
kmap("n", "<leader>dr", ":lua require'dap'.repl.toggle()<CR>")
kmap("n", "<F4>", ":lua require'dap'.run_last()<CR>")
kmap("n", "<F5>", ":lua require'dap'.continue()<CR>")
kmap("n", "<leader>dc", ":lua require'dap'.continue()<CR>")
kmap("n", "<F8>", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
kmap("n", "<F9>", ":lua require'dap'.toggle_breakpoint()<CR>")
kmap("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>")
kmap("n", "<F10>", ":lua require'dap'.step_over()<CR>")
kmap("n", "<F11>", ":lua require'dap'.step_into()<CR>")
kmap("n", "<F12>", ":lua require'dap'.step_out()<CR>")
kmap("n", "<Leader>dl", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")


kmap('n', '<Leader>R',      '<cmd>lua require("nvim2.utils").reload_config()<cr>', "Reload nvim config")
kmap("n", "<leader>T",      "<cmd>lua require('nvim2.plugins.custom.colorscheme_picker').find()<cr>", "Pick colorscheme")

-- formatter
-- kmap("n", "<leader>cf",     "<cmd>FormatWrite<cr>", "content format")
kmap("n", "<leader>ct",     "<cmd>lua require('nvim2.utils').toggle_autoformat()<cr>", "Toggle autoformat for ft")

-- LSPSAGA
kmap("n", "K",              "<cmd>Lspsaga hover_doc<cr>")
kmap("n", "<leader>rn",     "<cmd>Lspsaga rename<cr>")
kmap("n", "<leader>la",     "<cmd>Lspsaga code_action<cr>", "Code action")
kmap("v", "<leader>la",     "<cmd>Lspsaga range_code_action<cr>", "Code action", default_opts)
