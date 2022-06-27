package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/themes/luastatus/?.lua"
local color = require("color")

widget = {
    plugin = 'timer',
    cb = function()
        return {
            string.format(os.date(color.sep .. color.col1_ic_fg .. color.col1_ic_bg .. "  " .. color.col1_fg .. color.col1_bg .. " %H:%M ")), -- col0
						string.format(os.date(color.sep .. color.col0_ic_fg .. color.col0_ic_bg .. "  " .. color.col0_fg .. color.col0_bg .. " %a, %d %b ")), --col1
        }
    end,
}
