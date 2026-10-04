package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/themes/luastatus/?.lua"
local color = require("color")
package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/luastatus/lib/?.lua"
local gradient = require("gradient")

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

-- Colors, not from the theme: { content bg, icon bg }. The blue is claude.ai's
-- usage bar, the rest are gruvbox-compatible (no yellow, it clashes).
local blue = { { 0x2a, 0x78, 0xd6 }, { 0x22, 0x60, 0xab } }
local mauve = { { 0x85, 0x7b, 0x85 }, { 0x6f, 0x5f, 0x68 } }
local beige = { { 0xa3, 0x7d, 0x6a }, { 0x89, 0x5e, 0x51 } }
local orange = { { 0xfe, 0x80, 0x19 }, { 0xd6, 0x5d, 0x0e } }
local red = { { 0xfb, 0x49, 0x34 }, { 0xcc, 0x24, 0x1d } }

-- Blue for the first 10% used, then a steady drift through mauve and beige to
-- orange and red.
local stops = {
  { 10, blue }, { 30, mauve }, { 55, beige }, { 80, orange }, { 100, red },
}

local function segment(name, pct, limited)
  local text = pct and string.format(" %3d%% ", pct) or "   ? "
  if pct and limited then text = text .. "(?) " end
  local icon_bg = gradient(stops, pct or 0, 2)
  local content_bg = gradient(stops, pct or 0, 1)
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
