local v = vim

local Command = {}

-- Sets the number of arguments for the command
-- This converts to -nargs flag in :command
-- @param nargs { number | * | ? | + }
function Command:with_arg_count(count)
    self.nargs = count
    return self
end

-- Sets the completion method for the command
-- Value will be converted in to -complete flag in :command
-- @param completion_method {
--     arglist | augroup | buffer | behave | color | command | compiler |
--     cscope | dir | environment | event | expression | file | file_in_path |
--     filetype | function | help | highlight | history | locale | mapclear |
--     mapping | menu | messages | option | packadd | shellcmd | sign | syntax |
--     syntime | tag | tag_listfiles | user | var | custom | customlist
-- } method of the completion
-- @param arg { any } if completion_method takes an argument, pass in the arg
function Command:with_completion_method(completion_method, arg)
    self.completion_method = completion_method

    if completion_method == 'custom' or completion_method == 'customlist' then
        self.completion_method_arg = arg
    end

    return self
end

-- Sets the acceptable range of the command
-- Value will be converted into -rang flag in :command
-- @param range { N | % }
function Command:with_range(range)
    self.range = range
    return self
end
-- Sets the acceptable count of the command
-- Value will be converted into -count flag in :command
-- @param count { boolean }
function Command:with_count(count)
    self.count = count
    return self
end

-- Sets the scope of the command
-- Value will be converted into -addr flag in :command
-- @param addr {
--     lines | arguments | buffers | loaded_buffers |
--     windows | tabs | quickfix | other
-- }
function Command:with_addr(addr)
    self.addr = addr
    return self
end

-- Sets the availability of the command to buffer or not
-- Value will be converted into -buffer flag in :command
-- @param is_buffer_cmd { boolean } whether the command should be limited to
-- current buffer or not
function Command:is_buffer_cmd(is_buffer_cmd)
    self._is_buffer_cmd = is_buffer_cmd
    return self
end

-- Adds a command
-- @param name { string } name of the command
-- @param action { string } action of the command
function Command:add(name, action, abbreviation)
    local Options = {
        list = {},
    }

    function Options.add(option)
        table.insert(Options.list, option)
    end

    function Options.get()
        local options = ''

        for _, option in ipairs(Options.list) do
            options = options .. option .. ' '
        end

        return options:format(' $', '')
    end

    if self._is_buffer_cmd then
        Options.add('-buffer')
    end

    if type(action) == 'function' then
        local key = Global:save(action)
        action = string.format('lua Global:get(%s)()', key)
    end

    v.cmd(string.format(':command %s %s %s', Options.get(), name, action))

    if abbreviation then
        v.cmd(string.format(':abbreviate %s %s', abbreviation, name))
    end

    return self
end

-- Adds a list of command
-- @param comands { Array<{ name: string, action: string | function }> } commands to be added
function Command:add_all(commands)
    for _, command in ipairs(commands) do
        local name = command.name
        local action = command.action
        local abbreviation = command.abbreviation

        self:add(name, action, abbreviation)
    end

    return self
end

return Command
