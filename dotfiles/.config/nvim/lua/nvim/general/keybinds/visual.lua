local Shortcut = require('nvim.utils.nvim.shortcut')

Shortcut():mode('x'):options():noremap():next():keymaps({
    { 'n', 'j' },

    { 'e', 'k' },

    { 'i', 'l' },

    { 'l', 'e' },

    { 'k', 'n' },

    { 'j', 'i' },
})
