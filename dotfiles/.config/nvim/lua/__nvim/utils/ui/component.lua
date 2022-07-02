local class = require('pl.class')
local Random = require('nvim.utils.common.random')

local M = class()

function M:_init()
    self.id = Random.get_random_int()
    self.is_component = true
end

function M:set_parent(parent)
    self.parent = parent
    return self
end

function M:set_props(props)
    self.props = props
    return self
end

function M:set_children(children)
    self.children = children
    return self
end

return M
