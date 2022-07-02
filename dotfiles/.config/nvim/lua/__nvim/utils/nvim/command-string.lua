local M = {}

M.get_cmd_string = function(cmd)
    return '<cmd>' .. cmd .. '<cr>'
end

M.get_lua_cmd_string = function(cmd)
    return '<cmd>lua ' .. cmd .. '<CR>'
end

M.get_normal_cmd_string = function(cmd)
    return '<esc>' .. cmd
end

return M
