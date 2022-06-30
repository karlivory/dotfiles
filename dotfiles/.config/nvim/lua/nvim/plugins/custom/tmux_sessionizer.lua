local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local home = os.getenv "HOME"
local input = {'sh', home .. '/.config/vars/repos'}

local default_theme = {
  border = true,
  borderchars = {
    preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
    results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" }
  },
  layout_strategy = "bottom_pane",
  layout_config = {
    prompt_position = "bottom",
    height = 0.5
  },
  mappings = {},
  results_title = false,
  sorting_strategy = "descending",
  theme = "dropdown"
}

-- has to match tmux-sessionizer script
local function get_session_name(dir)
  local basename = dir:match("[^/]*$")
  session = basename:gsub("%.", "_")
  return session
end

local function isempty(s)
  return s == nil or s == ''
end

local function is_inside_tmux()
  local tmux = os.getenv "TMUX"
  return not isempty(tmux)
end

local function shell_command(cmd)
  local handle = io.popen(cmd)
  local output = nil
  if handle then
    output = handle:read('*a')
    handle:close()
  end
  return output
end

local function switch_to_session(dir)
  local session = get_session_name(dir)
  local tmux = is_inside_tmux()
  if not tmux then
    print("Not in tmux!")
    return
  end
  local session_exists = isempty(shell_command("tmux has-session -t=" .. session .. " 2>&1"))
  if session_exists then
    shell_command("tmux switch-client -t " .. session)
  else
    local res = shell_command("tmux new-session -ds " .. session .. " -c " .. dir .. " && tmux switch-client -t " .. session)
  end
end

M.find = function(opts)
  opts = opts or default_theme
  pickers.new(opts, {
    prompt_title = "tmux-sessionizer",
    finder = finders.new_oneshot_job(input),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<c-q>', false)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()[1]
        switch_to_session(selection)
      end)
      return true
    end,
  }):find()
end

return M
