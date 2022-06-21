local Variable = require('nvim.utils.nvim.variable')

-- This has nothing to do with neovim but some Neovide related variables
Variable.g({
    -- how long the cursor animation
    neovide_cursor_animation_length = 0.05,

    -- at what rate everthing rereshes
    neovide_refresh_rate = 60,

    -- cursor move animation
    neovide_cursor_vfx_mode = 'pixiedust',

    -- open in full screen mode
    neovide_fullscreen = false,

    -- antialiasin
    neovide_cursor_antialiasing = true,
})
