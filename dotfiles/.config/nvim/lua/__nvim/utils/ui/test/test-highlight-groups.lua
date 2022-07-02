local HighlightGroups = require('nvim.utils.nvim.highlighting.highlight-groups')
local ThemeManager = require('nvim.utils.nvim.theme.theme-manager')

local theme = ThemeManager.get_theme()

local test_highlight_groups = HighlightGroups({
    TestPending = { guifg = theme.normal.black },
    TestPassed = { guifg = theme.bright.green },
    TestSkipped = { guifg = theme.bright.yellow },
    TestError = { guifg = theme.bright.red },
})

return test_highlight_groups
