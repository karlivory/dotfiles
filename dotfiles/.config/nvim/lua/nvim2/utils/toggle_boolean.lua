-- src: https://github.com/rmagatti/alternate-toggler/blob/main/lua/alternate-toggler.lua
local boolean_values = {
  ["true"] = "false",
  ["True"] = "False",
  ["TRUE"] = "FALSE",
  ["yes"] = "no",
  ["Yes"] = "No",
  ["YES"] = "NO",
  ["1"] = "0",
}

local search_by_order = {
  "true",
  "True",
  "yes",
  "1",
  "TRUE",
  "YES",
}

vim.tbl_add_reverse_lookup(boolean_values)

-- yikes
return function()
  local pos = vim.api.nvim_win_get_cursor(0)
  local row = pos[1]
  local col = pos[2]
  -- get line based on row num
  if not row or not col then
    print("ERROR! Could not get row and col number")
    return
  end
  row = row - 1
  local max_word_len = 5
  local start_index = math.max(0, col - max_word_len)
  local lookback = col - start_index
  print(lookback)

  local line_text = vim.api.nvim_buf_get_text(0, row, start_index, row, -1, {})[1]

  local swap_index = nil
  local swap_to = nil
  local swapped_from = nil
  for _, toggleable in ipairs(search_by_order) do
    local search_start_index = math.max(0, lookback - #toggleable + 2)
    local true_found = string.find(line_text, toggleable, search_start_index)
    search_start_index = math.max(0, lookback - #boolean_values[toggleable] + 2)
    local false_found = string.find(line_text, boolean_values[toggleable], search_start_index)

    if true_found or false_found then
      local t = false
      if true_found and false_found then
        if true_found < false_found then
          t = true
        end
      elseif true_found then
        t = true
      end
      if t then
        swap_index = true_found
        swapped_from = toggleable
        swap_to = boolean_values[toggleable]
      else
        swap_index = false_found
        swapped_from = boolean_values[toggleable]
        swap_to = toggleable
      end
    end
  end

  if swap_index then
    local offset = #swapped_from - #swap_to
    local res = string.sub(line_text, 0, swap_index - 1)
      .. swap_to
      .. string.sub(line_text, swap_index + #swapped_from, -1)
    -- print(res)
    vim.api.nvim_buf_set_text(0, row, start_index, row, start_index + #line_text, { res })
  else
    -- print("Nothing to toggle.")
  end
end
