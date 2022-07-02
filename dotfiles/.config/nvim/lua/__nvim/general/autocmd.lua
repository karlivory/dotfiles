local ThemeManager = require('nvim.utils.nvim.theme.theme-manager')
local HighlightGroups = require('nvim.utils.nvim.highlighting.highlight-groups')
local highlighter = require('nvim.utils.nvim.highlighting.highlighter')

local theme = ThemeManager.get_theme()

local highlight_groups = HighlightGroups({
    TextYank = { guibg = theme.normal.yellow, guifg = theme.normal.black },
})

highlighter:new():add(highlight_groups):register_highlights()

-- highlight text on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = highlight_groups.TextYank.name,
            timeout = 300,
            on_visual = true,
        })
    end,
})
