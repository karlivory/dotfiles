return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    source_selector = {
      sources = {
        "filesystem",
        -- "buffers",
        -- "git_status",
      },
    },
    default_source = "filesystem",
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
        },
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
        -- ["<c-S-TAB>"] = "prev_source",
        -- ["<c-Tab>"] = "next_source",
        ["<C-w>s"] = "open_split",
        ["<C-w>v"] = "open_vsplit",
        ["?"] = "show_help",
        ["R"] = "refresh",
        ["a"] = { "add", config = { show_path = "relative" } }, -- show_path: "none", "relative", "absolute"
        ["d"] = "delete",
        ["o"] = "open",
        ["p"] = "paste_from_clipboard",
        ["q"] = "close_window",
        ["r"] = "rename",
        ["w"] = "close_node",
        ["x"] = "cut_to_clipboard",
        ["y"] = "copy_to_clipboard",
        --------------- UNBINDS ------------------
        --- NB! ctrl commands have to be in format: C-f, C-w and so on
        ["<C-f>"] = function(state)
          local node = state.tree:get_node()
          local path = node.type == "directory" and node:get_id() or vim.fn.fnamemodify(node:get_id(), ":h")

          require("snacks").picker.files {
            cwd = path,
            hidden = true,
            title = "[DIR] Files in " .. path,
          }
        end,
        ["<space>fw"] = function(state)
          local node = state.tree:get_node()
          local path = node.type == "directory" and node:get_id() or vim.fn.fnamemodify(node:get_id(), ":h")

          require("snacks").picker.grep {
            cwd = path,
            hidden = true,
            title = "[DIR] Grep in " .. path,
          }
        end,
        ["<C-x>"] = function(_) require("plugins.custom.tmux_sessionizer").find() end,
        ["/"] = false,
        ["<"] = false,
        ["<bs>"] = false,
        ["<c-x>"] = false,
        ["<cr>"] = false,
        ["<space>"] = false,
        [">"] = false,
        ["A"] = false,
        ["C"] = false,
        ["H"] = false,
        ["S"] = false,
        ["[g"] = false,
        ["]g"] = false,
        ["c"] = false,
        ["f"] = false,
        ["h"] = false,
        ["m"] = false,
        ["s"] = false,
        ["t"] = false,
        ["oc"] = false,
        ["od"] = false,
        ["og"] = false,
        ["om"] = false,
        ["on"] = false,
        ["os"] = false,
        ["ot"] = false,
      },
    },
    event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function(_) vim.cmd [[ setlocal nu rnu ]] end,
      },
      {
        event = "file_opened",
        handler = function(_)
          -- triggered on file_opened
          -- vim.cmd([[Neotree close]])
        end,
        id = "id_file_opened",
      },
    },
  },
}
