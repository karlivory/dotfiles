package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/themes/luastatus/?.lua"
local color = require("color")
package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/luastatus/lib/?.lua"
local gradient = require("gradient")

-- Colors, not from the theme: { content bg, icon bg }, gruvbox.
local red = { { 0xfb, 0x49, 0x34 }, { 0xcc, 0x24, 0x1d } }
local orange = { { 0xfe, 0x80, 0x19 }, { 0xd6, 0x5d, 0x0e } }
local yellow = { { 0xfa, 0xbd, 0x2f }, { 0xd7, 0x99, 0x21 } }

-- Yellow when full, then orange, red when low.
local stops = {
  { 15, red }, { 55, orange }, { 100, yellow },
}

widget = luastatus.require_plugin('battery-linux').widget {
  period = 2,
  cb = function(t)
    local symbol = ({
      Charging    = 'bc',
      Discharging = 'bd',
    })[t.status] or 'bd'
    local rem_seg
    local capacity = t.capacity
    if (t.capacity) then
      if t.rem_time then
        local h = math.floor(t.rem_time)
        local m = math.floor(60 * (t.rem_time - h))
        rem_seg = string.format('%2dh%02dm ', h, m)
      end
      local icon = color.sep .. color.col1_ic_fg .. gradient(stops, capacity, 2) ..
        ' ' .. symbol .. ' '
      local content = color.col1_fg .. gradient(stops, capacity, 1) ..
        string.format(" %3d%% ", capacity)
      return {
        icon .. content,
        rem_seg,
      }
    end
    return nil
  end,
}
