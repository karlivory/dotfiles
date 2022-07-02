local Event = require('nvim.utils.event')

local M = {}

function M:init(init_state)
    self.state = init_state
    self.event = Event()
    return self
end

function M:update(state)
    self.state = state
end

function M:add_listener(callback)
    self.event:add_listener('changed', callback)
end

return M
