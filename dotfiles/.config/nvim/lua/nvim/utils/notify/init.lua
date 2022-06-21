---@diagnostic disable: different-requires
local notify = require('notify')
local class = require('pl.class')

local Notify = class()

function Notify:_init(config)
    self.config = config
end

function Notify.notify(self, message, type)
    notify(message, type, self.config)
end

function Notify.success(self, message)
    self:notify(message, 'INFO')
end

function Notify.error(self, message)
    self:notify(message, 'ERROR')
end

function Notify.warn(self, message)
    self:notify(message, 'WARN')
end

function Notify.info(self, message)
    self:notify(message, 'INFO')
end

function Notify.debug(self, message)
    self:notify(message, 'DEBUG')
end

function Notify.trace(self, message)
    self:notify(message, 'TRACE')
end

return Notify
