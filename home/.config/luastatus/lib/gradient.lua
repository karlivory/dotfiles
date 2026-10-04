-- Blends widget colors by percentage; the palettes live in the widgets.
-- stops: { { percent, { content_bg, icon_bg } }, ... } in ascending percent,
-- where each bg is { r, g, b }. which: 1 for the content bg, 2 for the icon bg.
-- Returns a dwm "^b#rrggbb^" escape; outside the stops the end colors apply.
return function(stops, pct, which)
  local lo, hi = stops[1], stops[#stops]
  for i = 2, #stops do
    if pct <= stops[i][1] then
      lo, hi = stops[i - 1], stops[i]
      break
    end
  end
  local t = 0
  if hi[1] ~= lo[1] then t = math.min(1, math.max(0, (pct - lo[1]) / (hi[1] - lo[1]))) end
  local c = {}
  for k = 1, 3 do
    c[k] = math.floor(lo[2][which][k] + (hi[2][which][k] - lo[2][which][k]) * t + 0.5)
  end
  return string.format("^b#%02x%02x%02x^", c[1], c[2], c[3])
end
