local augroup = vim.api.nvim_exec
local cmd = vim.api.nvim_command
local utils = require('nvim2.utils.core')

-- Auto format
utils.autocommand_by_filetypes(
    require('nvim2.settings').autoformat.filetypes,
    'BufWritePre',
    [[lua require('format').format()]]
)

-- Briefly highlight text post yank
local group = vim.api.nvim_create_augroup('YankHighlight', {}) -- not needed?
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({ timeout = 60 })
    end,
    group = group
})

local autocmd = vim.api.nvim_create_autocmd
-- Don't auto commenting new lines
autocmd('BufEnter', {
  pattern = '*',
  command = 'set fo-=c fo-=r fo-=o'
})

-- Code action
utils.autocommand_by_filetypes(
    require('nvim2.settings').codeaction.filetypes,
    'CursorHold,CursorHoldI',
    [[lua require('utils.lightbulb').code_action()]]
)

-- augroup(
--     [[
-- augroup Config
--     autocmd!
--     autocmd InsertEnter * set nocursorline
--     autocmd InsertLeave * set cursorline
--     autocmd! BufEnter * if &ft ==# 'help' | wincmd L | endif
--     autocmd bufenter * if (winnr("$") == 2 && &filetype == "Yanil") | q | endif
--     autocmd BufNewFile,BufRead *.sol set filetype=solidity
-- augroup END
-- ]],
--     true
-- )

-- augroup(
--     [[
-- augroup StatusLine
--     autocmd!
--     autocmd BufEnter * lua require('nvim2.statusline').load()
--     autocmd BufWritePost * lua require('nvim2.statusline').load()
--
--     autocmd FileType dapui* lua require('nvim2.statusline').load()
--     autocmd FileType dap-repl lua require('nvim2.statusline').load()
--     autocmd FileType aerial lua require('nvim2.statusline').load()
-- augroup END
-- ]],
--     true
-- )

-- augroup(
--     [[
-- augroup Highlight
--     autocmd!
--     autocmd FileType dapui* setlocal winhighlight=Normal:DapUINormal
--     autocmd FileType aerial setlocal winhighlight=Normal:AerialNormal
--     autocmd FileType DiffviewFiles setlocal winhighlight=Normal:DiffviewFilesNormal
-- augroup END
-- ]],
--     true
-- )
