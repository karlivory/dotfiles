local nvimtree = require("nvim-tree")

local options = {
    filters = {
        dotfiles = false,
        exclude = { "custom" },
    },
    disable_netrw = true,
    hijack_netrw = true,
    ignore_ft_on_setup = { "alpha" },
    open_on_tab = false,
    hijack_cursor = true,
    hijack_unnamed_buffer_when_opening = false,
    update_cwd = true,
    update_focused_file = {
        enable = true,
        update_cwd = false,
    },
    view = {
        side = "left",
        width = 50,
        hide_root_folder = true,
        mappings = {
            list = {
                { key = "<C-e>", action = "" }
            }
        }
    },
    git = {
        enable = true,
        ignore = true,
    },
    actions = {
        open_file = {
            resize_window = true,
            quit_on_open = true
        },
    },
    renderer = {
        highlight_git = false,
        highlight_opened_files = "none",

        indent_markers = {
            enable = false,
        },
        icons = {
            padding = " ",
            symlink_arrow = " ➛ ",
            git_placement = "after",
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
            },
            glyphs = {
                default = "",
                symlink = "",
                folder = {
                    default = "",
                    empty = "",
                    empty_open = "",
                    open = "",
                    symlink = "",
                    symlink_open = "",
                    arrow_open = "",
                    arrow_closed = "",
                },
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★ ",
                    deleted = "",
                    ignored = "◌",
                },
            },
        },
    },
}

nvimtree.setup(options)


