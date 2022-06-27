package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/themes/luastatus/?.lua"
local color = require("color")

widget = luastatus.require_plugin('battery-linux').widget{
    period = 2,
    cb = function(t)
        local symbol = ({
            Charging    = '',
            Discharging = '',
        })[t.status] or ''
        local rem_seg
        local capacity = t.capacity
        if(t.capacity) then
          if t.rem_time then
            local h = math.floor(t.rem_time)
            local m = math.floor(60 * (t.rem_time - h))
            rem_seg = string.format('%2dh%02dm ', h, m)
          end
          local icon = color.sep
          if(capacity < 15) then
            icon = icon .. color.warn_fg .. color.warn_bg
          else
            icon = icon .. color.col2_ic_fg .. color.col2_ic_bg
          end
          icon = icon .. ' ' .. symbol .. ' '
          local content = color.col2_fg .. color.col2_bg .. string.format(" %3d%% ", capacity)
          return {
            icon .. content,
            rem_seg,
          }
        end
        return nil
    end,
}
