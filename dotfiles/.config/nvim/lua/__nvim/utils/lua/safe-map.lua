local class = require('pl.class')
local Map = require('pl.Map')
local List = require('pl.List')

local SafeMap = class(Map)

function SafeMap:_init(allowed_keys, map)
    assert(
        List:class_of(allowed_keys),
        'expected allowed_keys to be type List but passed '
            .. tostring(allowed_keys)
    )

    self.allowed_keys = allowed_keys

    if map then
        assert(
            type(map) == 'table',
            'expected map to be a table but passed ' .. tostring(type(map))
        )

        for key, _ in pairs(map) do
            assert(
                allowed_keys:contains(key),
                'expected map keys to be one of '
                    .. tostring(allowed_keys)
                    .. ' but passed '
                    .. key
            )
        end

        self:super(map)
    end
end

function SafeMap.set(self, key, value)
    assert(
        self.allowed_keys:contains(key),
        'expected key to be one of '
            .. tostring(self.allowed_keys)
            .. ' but passed '
            .. key
    )

    Map.set(self, key, value)
end

return SafeMap
