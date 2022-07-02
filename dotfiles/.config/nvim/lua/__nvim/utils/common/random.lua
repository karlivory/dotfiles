local M = {}

function M.get_random_int()
    return math.random(os.time())
end

return M
