require('bufferline').setup({
    options = {
        indicator_icon = '▌',
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(count, _)
            return '(' .. count .. ')'
        end,
        -- offsets = sidebar.sidebar_title,
        show_buffer_close_icons = false,
        show_close_icon = false,
        enforce_reqular_tabs = true,
    },
})

