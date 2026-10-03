package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/themes/luastatus/?.lua"
local color = require("color")

-- A blank dark-grey box separating groups of widgets.
local background = "#32302f"
local width = 3 -- spaces

widget = {
  plugin = 'timer',
  opts = { period = 3600 },
  cb = function()
    return color.sep .. "^b" .. background .. "^" .. string.rep(" ", width) .. "^d^"
  end,
}
