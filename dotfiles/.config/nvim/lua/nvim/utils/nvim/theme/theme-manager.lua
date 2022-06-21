local term_sexy = require('nvim.utils.nvim.theme.term_sexy')

local M = {}

function M.set_theme(theme)
    M.theme = theme
end

function M.get_theme()
    return M.theme or term_sexy
end

return M
