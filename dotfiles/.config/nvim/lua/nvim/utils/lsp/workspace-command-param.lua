local class = require('pl.class')
local WorkspaceCommandParam = class()

function WorkspaceCommandParam:_init(arg)
    if type(arg) == 'string' then
        self.command = arg
    elseif type(arg) == 'table' then
        self.command = arg.command
        self.arguments = arg.arguments
    end
end

return WorkspaceCommandParam
