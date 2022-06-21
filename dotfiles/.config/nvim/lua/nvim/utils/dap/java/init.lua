local class = require('pl.class')
local List = require('pl.List')
local Promise = require('promise')
local Client = require('nvim.utils.lsp.java.client')
local TestKind = require('nvim.utils.lsp.java.test-kind')
local TestLevel = require('nvim.utils.lsp.java.test-level')

local JUnit = require('nvim.utils.dap.java.test.junit')

local v = vim
local api = v.api

local function flatten_classpaths(classpaths)
    local flatten_classpath_list = {}

    for _, classpath in ipairs(classpaths) do
        for _, path in ipairs(classpath) do
            table.insert(flatten_classpath_list, path)
        end
    end

    return flatten_classpath_list
end

local JavaDap = class()

function JavaDap:_init()
    self.client = Client
    self.test_handlers = {}
    self.test_handlers[TestKind.JUnit] = JUnit()
end

--- Start the debug session
-- @returns { Promise } promise with the port number
function JavaDap.start_debug_session(self)
    return self.client.start_debug_session()
end

--- Returns project name and classpaths for each and every main class
-- @returns { Promise } classpath information
function JavaDap.get_resolved_main_classes(self)
    return self.client.resolve_main_class():thenCall(function(main_classes)
        -- result sample
        --
        -- { {
        --  filePath = "/home/s1n7ax/Workspace/demo/src/main/java/com/example/demo/DemoApplication.java",
        --  mainClass = "com.example.demo.DemoApplication",
        --  projectName = "demo"
        --  } }

        local resolve_classpath_promise_list = {}

        for _, main_class in ipairs(main_classes) do
            local project_name = main_class.projectName
            local class_name = main_class.mainClass

            local promise = self.client.resolve_classpath(
                class_name,
                project_name
            )

            table.insert(resolve_classpath_promise_list, promise)
        end

        return Promise.all(resolve_classpath_promise_list):thenCall(
            function(classpaths)
                local main_class_list_with_classpaths = {}

                for index, main_class in ipairs(main_classes) do
                    table.insert(main_class_list_with_classpaths, {
                        project_name = main_class.projectName,
                        class_name = main_class.mainClass,
                        file_path = main_class.filePath,
                        classpath = flatten_classpaths(classpaths[index]),
                    })
                end

                return main_class_list_with_classpaths
            end
        )
    end)
end

--- Creates a dap run configuration using the given information
function JavaDap.create_debug_config(_, project_name, class_name, classpath)
    return {
        name = string.format('Launch -> %s -> %s', project_name, class_name),
        projectName = project_name,
        mainClass = class_name,
        classPaths = v.tbl_flatten(classpath),
        modulePaths = {},
        request = 'launch',
        type = 'java',
    }
end

--- Returns the dap java configuration
-- @returns { Promise } dap configuration
function JavaDap.get_dap_config(self)
    return self:get_resolved_main_classes():thenCall(function(main_classes)
        -- class paths result structure is
        --
        --  { {
        --  class_name = "com.example.demo.DemoApplication",
        --  classpaths = {"path"},
        --  file_path = "/home/s1n7ax/Workspace/demo/src/main/java/com/example/demo/DemoApplication.java",
        --  project_name = "demo"
        --  } }

        local classpath_list = List(main_classes)

        return classpath_list:map(function(main_class)
            return self:create_debug_config(
                main_class.project_name,
                main_class.class_name,
                main_class.classpath
            )
        end)
    end)
end

function JavaDap.run_test(self, buffer, test_filter)
    assert(test_filter, 'Test filter should be passed')

    return self.client.test.find_test_types_and_methods(buffer):thenCall(
        function(tests)
            if not tests then
                error('Unable to find any tests')
            end

            local test = test_filter(tests)

            if not test then
                error('Test filter did not pass any test')
            end

            local test_kind = test.testKind
            local test_handler = self.test_handlers[test_kind]

            if not test_handler then
                error('Cannot find test handler for test kind ' .. test_kind)
            end

            return test_handler:run(
                test.projectName,
                test.testKind,
                test.testLevel,
                test.testNames
            )
        end
    )
end

function JavaDap.run_current_test_class(self)
    local buffer = api.nvim_get_current_buf()

    return self:run_test(buffer, function(tests)
        for _, test in ipairs(tests) do
            if test.testLevel == TestLevel.Class then
                test.testNames = { test.fullName }
                return test
            end
        end
    end)
end

function JavaDap.run_current_test_on_cursor(self)
    local buffer = api.nvim_get_current_buf()
    local cursor = vim.api.nvim_win_get_cursor(0)

    local function filter(tests)
        for _, test in ipairs(tests) do
            if
                test.testLevel ~= TestLevel.Method
                and self.__is_test_in_range(test, cursor)
            then
                if test.children then
                    return filter(test.children)
                else
                    test.testNames = { test.fullName }
                    return test
                end
            end

            -- method type test
            if self.__is_test_in_range(test, cursor) then
                test.testNames = { test.jdtHandler }

                return test
            end
        end
    end

    return self:run_test(buffer, filter)
end

function JavaDap.__is_test_in_range(test, cursor)
    local curr_line, curr_column = cursor[1], cursor[2]
    local start, finish = test.range['start'], test.range['end']
    local start_line, finish_line = (start.line + 1), (finish.line + 1)
    local start_column, finish_column = (start.character + 1), finish.character

    if start_line < curr_line and finish_line > curr_line then
        return true
    elseif start_line == curr_line and start_column <= curr_column then
        return true
    elseif finish_line == curr_line and finish_column >= curr_column then
        return true
    end

    return false
end

return JavaDap
