local class = require('pl.class')
local List = require('pl.List')
local Map = require('pl.Map')
local Assert = require('nvim.utils.validator.assert')
local Event = require('nvim.utils.event')
local EventType = require('nvim.utils.lsp.config.event')

local Config = class(Map)

function Config:_init()
    self.event = Event()
    self.on_attach = self:get_on_attach()
end

--- Append on attach callback to config
-- @param { function } callback - callback to be attached
function Config.add_listener(self, event, listener)
    self.event:add_listener(event, listener)
end

--- Remove on attach callback
-- @param { function } callback - callback to be attached
function Config.remove_listener(self, event, callback)
    self.event:remove_listener(event, callback)
end

--- Set config option
-- IF there is an existing value, this will throw an error
--
-- @param { string } option - name of the option
-- @param { any } value - the value to be appended
function Config.set_option(self, option, value)
    self:set(option, value)
end

--- Append item to config option
-- This assumes the value of the option is a List
-- IF the value is falsy, then new List will be assigned before appending
--
-- @param { string } option - name of the option
-- @param { any } value - the value to be appended
function Config.append_option(self, option, value)
    -- if no value, assign a new List
    if not self:get(option) then
        self:set(option, List())
    end

    Assert:is_instance_of(List, self:get(option), nil, 'List')

    self:get(option):append(value)
end

--- Returns a function that dispatches SERVER_READY for the first time and
-- ATTACH event on consequent events
function Config.get_on_attach(self)
    local this = self

    local callback = nil

    local function attach_callback(...)
        this.event:dispatch(EventType.ATTACH, ...)
    end

    local function server_ready_callback(...)
        this.event:dispatch(EventType.SERVER_READY, ...)
        this.event:dispatch(EventType.ATTACH, ...)
        callback = attach_callback
    end

    callback = server_ready_callback

    local function on_attach()
        callback()
    end

    return on_attach
end

return Config
