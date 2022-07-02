-- Common module define reusable functions
-- @module Common
local M = {}

-- check passed value is a table
--
-- @param arg value that needs to be checked
function M.is_table(value)
    if type(value) == 'table' then
        return true
    else
        return false
    end
end

return M
