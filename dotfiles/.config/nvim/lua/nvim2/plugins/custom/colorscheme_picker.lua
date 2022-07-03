local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local themes = {
  ["gruvbox"] = {
    colorscheme = "gruvbox",
    setup = function()
      vim.opt.background = "dark"
    end
  },
  ["gruvbox-light"] = {
    colorscheme = "gruvbox",
    setup = function()
      vim.opt.background = "light"
    end
  },
  ["catppuccin-latte"] = {
    colorscheme = "catppuccin",
    setup = function()
      vim.g.catppuccin_flavour = "latte"
    end
  },
  ["catppuccin-frappe"] = {
    colorscheme = "catppuccin",
    setup = function()
      vim.g.catppuccin_flavour = "frappe"
    end
  },
  ["catppuccin-macchiato"] = {
    colorscheme = "catppuccin",
    setup = function()
      vim.g.catppuccin_flavour = "macchiato"
    end
  },
  ["catppuccin-mocha"] = {
    colorscheme = "catppuccin",
    setup = function()
      vim.g.catppuccin_flavour = "mocha"
    end
  },
  ["onenord"] = {
    colorscheme = "onenord",
    setup = function()
      vim.opt.background = "dark"
    end
  },
  ["onenord-light"] = {
    colorscheme = "onenord",
    setup = function()
      vim.opt.background = "light"
    end
  },
  ["sonokai"] = {
    colorscheme = "sonokai",
    setup = function()
      vim.g.sonokai_style = "default"
      vim.opt.background = "dark"
    end
  },
  ["sonokai-atlantis"] = {
    colorscheme = "sonokai",
    setup = function()
      vim.g.sonokai_style = "atlantis"
      vim.opt.background = "dark"
    end
  },
  ["sonokai-andromeda"] = {
    colorscheme = "sonokai",
    setup = function()
      vim.g.sonokai_style = "andromeda"
      vim.opt.background = "dark"
    end
  },
  ["sonokai-shusia"] = {
    colorscheme = "sonokai",
    setup = function()
      vim.g.sonokai_style = "shusia"
      vim.opt.background = "dark"
    end
  },
  ["sonokai-maia"] = {
    colorscheme = "sonokai",
    setup = function()
      vim.g.sonokai_style = "maia"
      vim.opt.background = "dark"
    end
  },
  ["sonokai-espresso"] = {
    colorscheme = "sonokai",
    setup = function()
      vim.g.sonokai_style = "espresso"
      vim.opt.background = "dark"
    end
  },
}

-- is there a more idiomatic way? make sure gruvbox is first entry
local theme_keys = { "gruvbox" }
for key, _ in pairs(themes) do
  if(key ~= "gruvbox") then
    theme_keys[#theme_keys+1] = key
  end
end

M.find = function(opts)
  opts = opts or require('telescope.themes').get_ivy()
  pickers.new(opts, {
    prompt_title = "Colorscheme",
    finder = finders.new_table(theme_keys),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<c-q>', false)
      map('i', '<esc>', function()
        actions.close(prompt_bufnr)
      end)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()[1]
        themes[selection].setup()
        require("nvim2.utils").change_colorscheme(themes[selection].colorscheme)
      end)
      return true
    end,
  }):find()
end

return M


