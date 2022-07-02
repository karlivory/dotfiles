local M = {}

function M.escape_pattern(text)
    return text:gsub('([^%w])', '%%%1')
end

return M
