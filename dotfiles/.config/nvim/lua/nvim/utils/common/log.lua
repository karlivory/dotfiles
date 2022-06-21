local v = vim

local M = {}

function M.ins(...)
    print(v.inspect(...))
end

return M
