return {
  close_if_last_window = true,
  filesystem = {
    use_libuv_file_watcher = true,
    filtered_items = {
      visible = false, -- when true, they will just be displayed differently than normal items
      hide_gitignored = true,
      hide_dotfiles = false,
      -- show_hidden_count = false,
    },
    window = {
      mappings = {
        ["."] = "toggle_hidden",
        ["S"] = false,
        ["s"] = false,
        ["<space>"] = false,
        ["<cr>"] = false,
        ["o"] = "open",
        ["<c-w>s"] = "open_split",
        ["<c-w>v"] = "open_vsplit",
        ["t"] = false,
        ["C"] = false,
        ["w"] = "close_node",
        ["a"] = {
          "add",
          config = {
            show_path = "relative", -- "none", "relative", "absolute"
          },
        },
        ["r"] = "rename",
        ["A"] = false,
        ["d"] = "delete",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["c"] = false, -- takes text input for destination, also accepts the optional config.show_path option like "add":
        ["m"] = false, -- takes text input for destination, also accepts the optional config.show_path option like "add".
        ["q"] = "close_window",
        ["R"] = "refresh",
        ["?"] = "show_help", -- This shows the customized keymaps
        ["<bs>"] = false,
        ["h"] = false,
        ["H"] = false,
        ["/"] = false,
        ["f"] = false,
        ["<c-x>"] = false,
        ["[g"] = false,
        ["]g"] = false,
      }
    },
  },
  window = {
    position = "left",
    width = 50,
    mapping_options = {
      noremap = true,
      nowait = true,
    },
    mappings = {
      -- unmap some defaults
      ["<"] = false,
      [">"] = false,
      ["<c-S-TAB>"] = "prev_source",
      ["<c-Tab>"] = "next_source",
    },
  },
  event_handlers = {
    {
      event = "file_opened",
      handler = function(_)
        vim.cmd([[Neotree close]])
      end,
      id = "id_file_opened",
    },
  }
}
