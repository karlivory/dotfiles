package.path = package.path .. ";" .. os.getenv("HOME") .. "/.config/themes/luastatus/?.lua"
local color = require("color")

local line_pattern = '^%s*(%S+):' .. ('%s+(%d+)' .. ('%s+%d+'):rep(7)):rep(2) .. '%s*$'
local last_recv, last_sent = {}, {}

local PERIOD = 3

function format_bytes(num)
  precision = 1
  local res = string.format("%." .. precision .. "f", num)
  local len = string.len(res)
  if (len < 5) then
    res = string.rep(' ', 5 - len) .. res -- padding
  end
  return res
end

function format_iface(s)
  local len = string.len(s)
  res = s
  if (len > 4) then
    res = string.sub(s, 1, 2) .. '..'
  end
  return res
end

local function bytesToSize(bytes)
  kilobyte = 1024;
  megabyte = kilobyte * 1024;
  gigabyte = megabyte * 1024;
  terabyte = gigabyte * 1024;

  if ((bytes >= 0) and (bytes < kilobyte)) then
    return format_bytes(bytes) .. "  B"; -- extra space needed to match others
  elseif ((bytes >= kilobyte) and (bytes < megabyte)) then
    return format_bytes(bytes / kilobyte) .. ' KB';
  elseif ((bytes >= megabyte) and (bytes < gigabyte)) then
    return format_bytes(bytes / megabyte) .. ' MB';
  elseif ((bytes >= gigabyte) and (bytes < terabyte)) then
    return format_bytes(bytes / gigabyte) .. ' GB';
  elseif (bytes >= terabyte) then
    return format_bytes(bytes / terabyte) .. ' TB';
  else
    return ' TOO MUCH DATA! ';
  end
end


local function get_block(line, interface)
  local iface, recv, sent = line:match(line_pattern)
  assert(iface and recv and sent)

  -- Alternatively, you can filter out unneeded interfaces here, e.g.
  --   if iface ~= 'wlp2s0' then return nil end
  if iface == 'lo' then return nil end
  if iface ~= interface then return nil end

  recv, sent = tonumber(recv), tonumber(sent)
  local prev_recv, prev_sent = last_recv[iface], last_sent[iface]
  local res = nil
  if prev_recv and prev_sent then
    local delta_recv = recv - prev_recv
    local delta_sent = sent - prev_sent
    if (delta_recv >= 0 and delta_sent >= 0) and (recv > 0 and sent > 0) then
      res = string.format(' %s %s/s↓ %s/s↑ ',
        format_iface(iface),
        bytesToSize(delta_recv / PERIOD),
        bytesToSize(delta_sent / PERIOD)
      )
    end
  end
  last_recv[iface] = recv
  last_sent[iface] = sent
  return res
end

local function get_default_gw_if()
  local r = assert(io.open('/proc/net/route', 'r'))
  local count = 1
  for line in r:lines() do
    if (count == 2) then
      for w in line:gmatch("%S+") do return w end -- return the first word (it's the interface name)
    end
    count = count + 1
  end
end

widget = {
  plugin = 'timer',
  opts = { period = PERIOD },
  cb = function()
    local res = ""
    local gw_if = get_default_gw_if()
    local f = assert(io.open('/proc/net/dev', 'r'))
    for line in f:lines() do
      if not line:find('|') then -- skip the "header" lines
        local block = get_block(line, gw_if)
        if block then
          res = block
          break
        end
      end
    end
    f:close()
    local icon = ' n '
    return color.sep .. color.col1_ic_fg .. color.col1_ic_bg .. icon .. color.col1_fg .. color.col1_bg .. res
  end
}
