local Shortcut = require('nvim.utils.nvim.shortcut')

Shortcut():mode('t'):options():noremap():next():keymaps({
    -- to go to normal mode
    { 'nn', [[<c-\><c-n>]], {} },
})
