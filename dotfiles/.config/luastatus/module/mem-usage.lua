package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/themes/luastatus/?.lua"
local color = require("color")

widget = luastatus.require_plugin('mem-usage-linux').widget{
  timer_opts = {period = 2},
  cb = function(t)
    local used_kb = t.total.value - t.avail.value

    local icon = color.col1_ic_bg .. ' M ' 
    local content = string.format(color.col1_bg .. color.col1_fg .. ' %3.2f GB ', used_kb / 1024 / 1024)
    return color.sep .. icon .. content
  end,
}
