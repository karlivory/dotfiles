local class = require('pl.class')
local Map = require('pl.Map')
local List = require('pl.List')
local Assert = require('nvim.utils.validator.assert')

local Enum = class(Map)

function Enum:_init(values)
    if List:class_of(values) then
        local map = {}
        local index = 0

        values = values:foreach(function(value)
            index = index + 1
            map:set(value, index)
        end)
    end

    self:super(values)
end

return Enum
