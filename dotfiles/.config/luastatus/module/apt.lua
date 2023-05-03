package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/themes/luastatus/?.lua"
local color = require("color")

local function get_first_num(s)
  for w in s:gmatch("%S+") do return w end -- return the first word (it's the interface name)
end

widget = {
  plugin = 'timer',
  opts = {
    period = 900,
  },
  cb = function(t)
    local icon = color.sep -- .. color.col1_ic_fg
    local content = color.col1_fg .. color.col1_bg

    local apt_command = "/usr/lib/update-notifier/apt-check 2>&1 | cut -d ';' -f 1"
    local handle = io.popen(apt_command)
    local vol_result = handle:read("*a")
    handle:close()
    apt_result = tonumber(get_first_num(vol_result))

    if (apt_result == 0) then
      icon = icon .. color.col1_ic_fg .. color.col1_ic_bg .. ' p '
    else
      icon = icon .. color.warn_fg .. color.warn_bg .. ' ! '
    end

    apt_result = string.format("%2d", vol_result)

    content = content .. ' ' .. apt_result .. ' '
    return icon .. content
  end,
}
