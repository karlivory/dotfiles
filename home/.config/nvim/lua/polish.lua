-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

vim.api.nvim_del_keymap("n", "grr")
vim.api.nvim_del_keymap("n", "gra")
vim.api.nvim_del_keymap("n", "gri")
vim.api.nvim_del_keymap("n", "grn")
