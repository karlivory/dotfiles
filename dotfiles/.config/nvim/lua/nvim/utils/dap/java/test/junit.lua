local class = require('pl.class')
local Client = require('nvim.utils.lsp.java.client')
local dap = require('dap')
local TestResultParser = require('nvim.utils.dap.java.test.test-result-parser')

local loop = vim.loop

local JUnit = class()

function JUnit:_init()
    self.client = Client
end

function JUnit.run(self, project_name, test_kind, test_level, test_names)
    return self.client.test.junit.arguments(
        project_name,
        test_kind,
        test_level,
        test_names
    ):thenCall(function(launch_args)
        local config = JUnit.get_run_args(test_names[1], launch_args, true)

        return self:_run(config)
    end)
end

function JUnit._run(_, config)
    local server = nil
    local test_result_parser = TestResultParser()

    dap.run(config, {
        before = function(conf)
            server = loop.new_tcp()
            server:bind('127.0.0.1', 0)
            server:listen(128, function(err2)
                assert(not err2, err2)

                local conn = vim.loop.new_tcp()

                server:accept(conn)
                conn:read_start(test_result_parser.get_stream_reader(conn))
            end)

            conf.args = conf.args:gsub(
                '-port ([0-9]+)',
                '-port ' .. server:getsockname().port
            )
            return conf
        end,

        after = function()
            server:shutdown()
            server:close()
        end,
    })

    return test_result_parser
end

function JUnit.get_run_args(testName, launch_args, debug)
    return {
        projectName = launch_args.projectName,
        classPaths = launch_args.classpath,
        mainClass = 'org.eclipse.jdt.internal.junit.runner.RemoteTestRunner',
        args = table.concat(launch_args.programArguments, ' '),
        cwd = launch_args.workingDirectory,

        noDebug = not debug,
        request = 'launch',
        type = 'java',
        vmArgs = '-ea',
        name = testName,
        modulePaths = {},
    }
end

return JUnit
