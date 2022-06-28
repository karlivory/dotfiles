package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/themes/luastatus/?.lua"
local color = require("color")

fifo_path = os.getenv('HOME') .. '/.config/luastatus/fifo/.volume'
assert(os.execute('f=' .. fifo_path .. '; set -e; rm -f $f; mkfifo -m600 $f'))

local function get_first_num(s)
  for w in s:gmatch("%S+") do return w end -- return the first word (it's the interface name)
end

widget = {
  plugin = 'timer',
  opts = {
    fifo = fifo_path,
    period = 3,
  },
  cb = function(t)
    -- if t == 'fifo' then
    --   return {full_text = 'Thanks!'}
    -- end

    local icon = color.sep .. color.col1_ic_fg .. color.col1_ic_bg
    local content = color.col1_fg .. color.col1_bg

    local vol_command = "pulsemixer --get-volume"
    local handle = io.popen(vol_command)
    local vol_result = handle:read("*a")
    handle:close()
    vol_result = tonumber(get_first_num(vol_result))

    local mute_command = "pulsemixer --get-mute"
    local handle = io.popen(mute_command)
    local mute_result = handle:read("*a")
    handle:close()
    mute_result = tonumber(get_first_num(mute_result))
    if(mute_result == 1) then
      icon = icon .. ' 婢 '
    elseif(vol_result == 0) then
      icon = icon .. '  '
    elseif(vol_result <= 30) then
      icon = icon .. '  '
    else
      icon = icon .. ' 奔 '
    end

    vol_result = string.format("%3d", vol_result)

    content = content .. ' ' .. vol_result .. '% '
    return icon .. content
  end,
  event = function(t)
    -- opening the FIFO for writing here may, in some rare cases, block (and doing this from
    -- this process would lead to a deadlock), so we spawn another process to do it and do not
    -- wait for its termination (which would also lead to a deadlock).
    os.execute('exec touch ' .. fifo_path .. '&')
  end,
}
