local Assert = require('nvim.utils.validator.assert')
local Promise = require('promise')
local class = require('pl.class')
local WorkspaceCommandParam = require('nvim.utils.lsp.workspace-command-param')

local lsp = vim.lsp

local Client = class()

function Client:_init(arg)
    self.buffer = arg.buffer
    self.client = arg.client
end

--- Run workspace command
-- @param { WorkspaceCommandParam } command parameters
-- @returns { Promise<...any> } promise
function Client.execute_workspace_command(self, param)
    Assert:is_instance_of(
        WorkspaceCommandParam,
        param,
        nil,
        'WorkspaceCommandParam'
    )

    -- use the client if available
    if self.client then
        return Promise.new(function(response, reject)
            self.client.request(
                'workspace/executeCommand',
                param,
                function(error, ...)
                    if error then
                        reject(error)
                    else
                        response(...)
                    end
                end,
                self.buffer
            )
        end)
    end

    -- use client registered for the given buffer
    return Promise.new(function(response, reject)
        lsp.buf_request(
            self.buffer,
            'workspace/executeCommand',
            param,
            function(error, ...)
                if error then
                    reject(error)
                else
                    response(...)
                end
            end
        )
    end)
end

return Client
