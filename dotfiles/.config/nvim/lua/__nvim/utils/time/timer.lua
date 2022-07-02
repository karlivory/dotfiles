local class = require('pl.class')
local Table = require('nvim.utils.lua.list')
local socket = require('socket')

local M = class()

function M:_init()
    self.checkpoints = {}
end

function M:add_checkpoint(name)
    table.insert(self.checkpoints, {
        name = name,
        timestamp = socket.gettime() * 1000,
    })
end

function M:get_diff(...)
    local sne = self:_get_start_and_end_checkpoints(...)

    print(
        string.format(
            'From "%s" to "%s":: %d ms',
            sne[1].name,
            sne[2].name,
            sne[2].timestamp - sne[1].timestamp
        )
    )
end

function M:_get_start_and_end(...)
    local checkpoints = { ... }
    local start = 1
    local end_ = #self.checkpoints

    if #checkpoints == 2 then
        start = checkpoints[1]
        end_ = checkpoints[2]
    end

    if #checkpoints == 1 then
        start = checkpoints[1]
        end_ = checkpoints[#self.checkpoints]
    end

    return { start, end_ }
end

function M:_get_start_and_end_checkpoints(...)
    local start_end = self:_get_start_and_end(...)
    local start = start_end[1]
    local end_ = start_end[2]

    local start_checkpoint
    local end_checkpoint

    if type(start) == 'string' then
        start_checkpoint = Table.find(self.checkpoints, function(checkpoint)
            return checkpoint.name == start
        end)
    end

    if type(start) == 'number' then
        start_checkpoint = self.checkpoints[start]
    end

    if type(end_) == 'string' then
        end_checkpoint = Table.find(self.checkpoints, function(checkpoint)
            return checkpoint.name == end_
        end)
    end

    if type(end_) == 'number' then
        end_checkpoint = self.checkpoints[end_]
    end

    return { start_checkpoint, end_checkpoint }
end

return M
