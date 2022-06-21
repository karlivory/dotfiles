local ThemeManager = require('nvim.utils.nvim.theme.theme-manager')
local HighlightGroup = require('nvim.utils.nvim.highlighting.highlight-groups')
local Highlighter = require('nvim.utils.nvim.highlighting.highlighter')

local theme = ThemeManager.get_theme()

local M = {}

local highlights = HighlightGroup({
    WinBarSeparator = { guifg = theme.bright.white },
    WinBarContent = { guifg = theme.bright.black, guibg = theme.bright.white },
    WinBarContentModified = {
        guifg = theme.bright.red,
        guibg = theme.bright.white,
    },
})

Highlighter:new():add(highlights):register_highlights()

M.eval = function()
    local file_path = vim.api.nvim_eval_statusline('%f', {}).str
    local modified = vim.api.nvim_eval_statusline('%m', {}).str == '[+]'
            and '  ⟴  '
        or ''

    file_path = file_path:gsub('/', ' ➤ ')

    return '%#WinBarSeparator#'
        .. ''
        .. '%*'
        .. '%#WinBarContent#'
        .. file_path
        .. '%*'
        .. '%#WinBarContentModified#'
        .. modified
        .. '%*'
        .. '%#WinBarSeparator#'
        .. ''
        .. '%*'
end

return M
