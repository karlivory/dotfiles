local LspClient = require('nvim.utils.lsp.client')
local WorkspaceCommandParam = require('nvim.utils.lsp.workspace-command-param')

local v = vim
local fn = v.fn

local self = {
    client = LspClient({
        buffer = 0,
    }),
}

local function get_uri(buffer)
    return v.uri_from_bufnr(buffer)
end

local function get_json(value)
    return fn.json_encode(value)
end

local Client = {
    --- Starts the debug session and returns the port number
    -- @returns { Promise<port> } port number
    start_debug_session = function()
        local cmd_param = WorkspaceCommandParam('vscode.java.startDebugSession')
        return self.client:execute_workspace_command(cmd_param)
    end,

    --- Returns all the main classes
    -- @returns
    resolve_main_class = function()
        local cmd_param = WorkspaceCommandParam('vscode.java.resolveMainClass')
        return self.client:execute_workspace_command(cmd_param)
    end,

    --- Returns the classpaths
    -- @param { string } class_name full name of the main class
    -- @param { ResolveClasspathCommandArguments } command arguments
    -- @returns {} class paths
    resolve_classpath = function(class_name, project_name)
        local cmd_param = WorkspaceCommandParam({
            command = 'vscode.java.resolveClasspath',
            arguments = { class_name, project_name },
        })

        return self.client:execute_workspace_command(cmd_param)
    end,

    test = {
        --- Returns the test information for a given buffer
        -- @param { number } buffer buffer number
        -- @param { FindTestTypesAndMethodsArguments } arguments arguments to pass to the command
        find_test_types_and_methods = function(buffer)
            local client = LspClient({
                buffer = buffer,
            })

            local cmd_param = WorkspaceCommandParam({
                command = 'vscode.java.test.findTestTypesAndMethods',
                arguments = { get_uri(buffer) },
            })

            return client:execute_workspace_command(cmd_param)
        end,

        junit = {
            --- Returns the test arguments
            -- @param projectName: string
            -- @param testKind: TestKind
            -- @param testLevel: TestLevel
            -- @param testNames: string[]
            arguments = function(project_name, test_kind, test_level, test_names)
                local cmd_param = WorkspaceCommandParam({
                    command = 'vscode.java.test.junit.argument',
                    arguments = {
                        get_json({
                            projectName = project_name,
                            testKind = test_kind,
                            testLevel = test_level,
                            testNames = test_names,
                        }),
                    },
                })

                return self.client:execute_workspace_command(cmd_param)
            end,
        },
    },

    project = {
        --- Returns the classpaths for given buffer
        -- @param { number } buffer buffer number
        -- @param { GetClasspathArguments } arguments to pass to the command
        get_classpaths = function(buffer, scope)
            local client = LspClient({
                buffer = buffer,
            })

            local cmd_param = WorkspaceCommandParam({
                command = 'java.project.getClasspaths',
                arguments = {
                    v.uri_from_bufnr(buffer),
                    get_json({
                        scope = scope,
                    }),
                },
            })

            return client:execute_workspace_command(cmd_param)
        end,
    },
}

return Client
