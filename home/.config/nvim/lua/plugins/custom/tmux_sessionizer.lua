local M = {}

local snacks = require "snacks"
local home = os.getenv "HOME"
local input_cmd = "sh " .. home .. "/.config/vars/repos"

local function isempty(s) return s == nil or s == "" end

local function is_inside_tmux() return not isempty(os.getenv "TMUX") end

local layout = {
  reverse = true,
  layout = {
    box = "vertical",
    position = "bottom",
    preview = false,
    height = 0.5,
    border = "top",
    title = "tmux-sessionizer",
    { win = "list", border = "none" },
    { win = "input", height = 1, border = "bottom" },
  },
  win = {
    input = {
      keys = {
        ["<C-x>"] = function(picker)
          picker:close()
          vim.schedule(function() vim.fn.system "tmux-sessionizer --last" end)
        end,
      },
    },
  },
}
local function shell_command(cmd)
  local handle = io.popen(cmd)
  local output = nil
  if handle then
    output = handle:read "*a"
    handle:close()
  end
  return output
end

local function get_repos()
  local output = shell_command(input_cmd)
  if output == nil then return {} end

  local items = {}
  local i = 0
  for line in output:gmatch "[^\r\n]+" do
    i = i + 1
    table.insert(items, {
      idx = i,
      score = i,
      text = line,
    })
  end

  return items
end

M.find = function()
  local repos = get_repos()
  if not is_inside_tmux() then
    vim.notify("Not inside tmux", vim.log.levels.WARN)
    return
  end

  snacks.picker.pick {
    title = "Tmux Sessionizer",
    reverse = true,
    items = repos,
    layout = layout,
    format = function(item) return { { item.text } } end,
    confirm = function(picker, item)
      picker:close()
      shell_command("tmux-sessionizer " .. item.text)
    end,
  }
end

return M
