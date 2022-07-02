local cast = require('nvim.utils.lua.cast')

local M = {}

function M.starts_with(str, starts_with_str)
    return string.sub(str, 1, string.len(starts_with_str)) == str
end

function M.contains(str, contains_str)
    return cast.toboolean(str:find(contains_str))
end

function M.split(str, separator)
    if separator == nil then
        separator = '%s'
    end
    local t = {}
    for match in string.gmatch(str, '([^' .. separator .. ']+)') do
        table.insert(t, match)
    end
    return t
end

function M.is_empty(str)
    assert(
        M.is_string(str),
        'expected str to be a string but passed ' .. tostring(str)
    )

    return str:match('^%s$')
end

function M.is_string(value)
    return type(value) == 'string'
end

function M.get_space_str(number_of_spaces)
    return string.format('%%-%ds', number_of_spaces):format('')
end

function M.get_line_iter(str)
    if str:sub(-1) ~= '\n' then
        str = str .. '\n'
    end

    return str:gmatch('(.-)\n')
end

function M.box_trim_lines(str)
    local new_str = ''

    for line in M.get_line_iter(str) do
        line = line:gsub('^%s+', '')
        line = string.gsub(line, '%s+$', '')
        new_str = new_str .. '\n' .. line
    end

    return new_str
end

return M
