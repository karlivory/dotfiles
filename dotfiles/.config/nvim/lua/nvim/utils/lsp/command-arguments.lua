local class = require('pl.class')
local List = require('pl.List')

---@diagnostic disable-next-line: undefined-global
local fn = vim.fn

local CommandArguments = class(List)

function CommandArguments.append_as_json(self, option)
    local json_str = fn.json_encode(option)
    self.options:append(json_str)
end

return CommandArguments
