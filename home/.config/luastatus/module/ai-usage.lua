package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/themes/luastatus/?.lua"
local color = require("color")

local home = os.getenv("HOME")

-- Keep the last reported percent when rate limited, even after its window resets.
local function percent(line)
  local pct, resets, suffix = (line or ""):match("^(%S+) (%d+)(.*)$")
  if not pct then return nil end
  local limited = suffix:find("?", 1, true) ~= nil
  if not limited and tonumber(resets) < os.time() then return 0, false end
  return tonumber(pct), limited
end

local function usage(tool)
  local h = io.popen(home .. "/git/dotfiles/dotfiles-personal/bin/usage " .. tool .. " 2>/dev/null")
  local line = h:read("*l")
  h:close()
  return percent(line)
end

-- Claude blue for the first 10% used, then light orange, dark orange and red.
local stops = {
  { 10, color.blue }, { 40, color.light_orange }, { 70, color.dark_orange }, { 100, color.red },
}

local function segment(name, pct, limited)
  local text = pct and string.format(" %3d%% ", pct) or "   ? "
  if pct and limited then text = text .. "(?) " end
  local icon_bg = color.gradient(stops, pct or 0, 2)
  local content_bg = color.gradient(stops, pct or 0, 1)
  return color.sep .. color.col0_ic_fg .. icon_bg .. " " .. name .. " " ..
    color.col0_fg .. content_bg .. text
end

widget = {
  plugin = 'timer',
  -- Check the cache each minute; the helper fetches every 2m or backs off 5m.
  opts = { period = 60 },
  cb = function()
    return segment("cl", usage("claude")) .. segment("cx", usage("codex"))
  end,
}
