local filesystem = {
  use_libuv_file_watcher = true,
  filtered_items = {
    visible = false, -- when true, they will just be displayed differently than normal items
    hide_gitignored = true,
    hide_dotfiles = false,
  },
}

local default_component_configs = {
  modified = {
    symbol = '',
    highlight = 'NeoTreeModified',
  },
  name = {
    trailing_slash = false,
    use_git_status_colors = false,
    highlight = 'NeoTreeFileName',
  },
  git_status = {
    symbols = {
      -- Change type
      added = '', -- or "✚", but this is redundant info if you use git_status_colors on the name
      modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
      -- Status type
      untracked = '',
      ignored = '',
      unstaged = '',
      staged = '',
      conflict = '',
    },
  },
}

local window = {
  position = "left",
  width = 50,
  mapping_options = {
    noremap = true,
    nowait = true,
  },
  mappings = {
    -- unmap some defaults
    ["K"] = function(state)
      local node = state.tree:get_node()
      print(vim.inspect(node)) -- example custom mapping
    end,
    ["S"] = "",
    ["s"] = "",
    ["<space>"] = "toggle_node",
    ["<2-LeftMouse>"] = "open",
    -- ["<cr>"] = "open",
    ["<cr>"] = function(_)
      print("Use o instead!")
    end,
    ["o"] = "open",
    ["<c-w>s"] = "open_split",
    ["<c-w>v"] = "open_vsplit",
    ["t"] = "",
    ["C"] = "",
    ["w"] = "close_node",
    ["a"] = {
      "add",
      config = {
        show_path = "relative" -- "none", "relative", "absolute"
      }
    },
    ["r"] = "rename",
    ["A"] = "",
    ["d"] = "delete",
    ["y"] = "copy_to_clipboard",
    ["x"] = "cut_to_clipboard",
    ["p"] = "paste_from_clipboard",
    ["c"] = "", -- takes text input for destination, also accepts the optional config.show_path option like "add":
    ["m"] = "", -- takes text input for destination, also accepts the optional config.show_path option like "add".
    ["q"] = "close_window",
    ["R"] = "refresh",
    ["?"] = "show_help", -- This shows the customized keymaps
    ["<bs>"] = "",
    ["."] = "toggle_hidden",
    ["H"] = "",
    ["/"] = "",
    ["f"] = "filter_on_submit",
    ["<c-x>"] = "clear_filter",
    ["[g"] = "",
    ["]g"] = "",
  }
}

local event_handlers = {
  {
    event = "file_opened",
    handler = function(_)
      vim.cmd[[NeoTreeClose]]
    end,
    id = "id_file_opened"
  }
}

require('neo-tree').setup({
  filesystem = filesystem,
  window = window,
  event_handlers = event_handlers,
  default_component_configs = default_component_configs
})

