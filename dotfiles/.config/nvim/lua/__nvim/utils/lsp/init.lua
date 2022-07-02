local lsp_config = require('lspconfig')
local Config = require('nvim.utils.lsp.config')
local LspEvent = require('nvim.utils.lsp.event')
local Event = require('nvim.utils.event')

local M = {
    lsp_event = Event(),
}

--- Add event listener
--
-- @param { Event } event - event type
-- @param { Function } listener - callback function to call on event
function M.add_listener(event, listener)
    M.lsp_event:add_listener(event, listener)
end

--- Setup language servers
function M.setup(servers)
    M.lsp_event:dispatch(LspEvent.START)

    for _, server_name in pairs(servers) do
        local conf = Config()

        M.lsp_event:dispatch(LspEvent.SERVER_SETUP, server_name, conf)

        lsp_config[server_name].setup(conf)

        M.lsp_event:dispatch(LspEvent.SERVER_SETUP_END, server_name, conf)
    end

    M.lsp_event:dispatch(LspEvent.END)
end

return M
