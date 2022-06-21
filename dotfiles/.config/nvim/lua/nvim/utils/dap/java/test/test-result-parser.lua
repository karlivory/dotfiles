local Event = require('nvim.utils.event')
local TestStatus = require('nvim.utils.dap.java.test.test-status')
local TestEventType = require('nvim.utils.dap.java.test.test-event-type')
local TestResultType = require('nvim.utils.dap.java.test.test-result-type')

local extend = vim.tbl_deep_extend

function TestResultParser()
    local M = {
        _event = Event(),
        _curr_result = {},
        _current_test_content = {},
        _is_test_result_inprogress = false,
    }

    -- Returns a callback function to read the tcp stream
    -- @param conn { TCPConnection } tcp connection
    function M.get_stream_reader(conn)
        return vim.schedule_wrap(function(err, buffer)
            assert(not err, err)

            if buffer then
                M._handle_buffer(buffer)
            else
                conn:close()
            end
        end)
    end

    function M.add_listener(event, listener)
        M._event:add_listener(event, listener)
    end

    function M.remove_listener(event, listener)
        M._event:remove_listener(event, listener)
    end

    -- Handle the buffer received from server and fire test events
    -- @param buffer { string } buffer received from server
    function M._handle_buffer(buffer)
        local lines = vim.split(buffer, '\n')

        for _, line in ipairs(lines) do
            -- TEST START
            if vim.startswith(line, TestResultType.TestStart) then
                M._is_test_result_inprogress = true
                M._curr_result.pending = true

                local test_data = M._parse_test_case_info(line)
                M._curr_result = extend('force', M._curr_result, test_data)

                M._event:dispatch(TestEventType.START, M._curr_result)

                goto continue
            end

            -- TEST END
            if vim.startswith(line, TestResultType.TestEnd) then
                M._is_test_result_inprogress = false
                M._curr_result.pending = false

                local test_result = M._parse_result(M._current_test_content)
                test_result = extend('force', M._curr_result, test_result)

                M._event:dispatch(TestEventType.COMPLETE, test_result)
                M._current_test_content = {}

                goto continue
            end

            -- TEST CONTENT
            if M._is_test_result_inprogress then
                table.insert(M._current_test_content, line)
            end

            ::continue::
        end

        M._event:dispatch(TestEventType.UPDATE, M._curr_result)
    end

    -- Returns the test case data from the test start tag
    -- @param line { string } test result start tag line
    -- @returns {{
    --     id: number
    --     name: string
    --     class: string
    -- }}
    function M._parse_test_case_info(line)
        local test_matches = vim.fn.matchlist(
            line,
            [[%TESTS *\(\d\),\(.*\)(\(.*\))]]
        )

        return {
            id = tonumber(test_matches[2]),
            name = test_matches[3],
            class = test_matches[4],
        }
    end

    -- Returns the tag information and it's content
    -- @param lines { Array<string> } test result buffer
    -- @param tagStart { TestResultType } syntax of the start tag
    -- @param tagEnd { TestResultType } syntax of the end tag
    -- @returns {
    --     tagStart: string
    --     tagEnd: string
    --     children: Array<string> tag content
    -- }
    function M._parse_tag_info(lines, tagStart, tagEnd)
        local sections = {}

        for i = 1, #lines, 1 do
            local section = {}
            local line = lines[i]

            if vim.startswith(line, tagStart) then
                section.tagStart = line

                local children_lines = {}

                if tagEnd then
                    for j = (i + 1), #lines, 1 do
                        line = lines[j]

                        if vim.startswith(line, tagEnd) then
                            section.tagEnd = line
                            i = j
                            break
                        end

                        table.insert(children_lines, line)
                    end
                end

                section.children = children_lines
                table.insert(sections, section)
            end
        end

        return sections
    end

    -- Returns the test result table form the result buffer
    -- @param lines { Array<string> } list of result string lines
    -- @returns {
    --     status: TestStatus,
    --     expected: Array<string>,
    --     actual: Array<string>,
    --     trace: Array<string>
    -- }
    function M._parse_result(lines)
        local result = {}

        -- passed
        local faliure_tag = M._parse_tag_info(lines, TestResultType.TestFailed)
        local error_tag = M._parse_tag_info(lines, TestResultType.TestError)

        if faliure_tag[1] or error_tag[1] then
            result.status = TestStatus.FAIL
        else
            result.status = TestStatus.PASS
        end

        if result.status == TestStatus.FAIL then
            -- expected
            local expected_tag = M._parse_tag_info(
                lines,
                TestResultType.ExpectStart,
                TestResultType.ExpectEnd
            )

            if #expected_tag > 0 then
                result.expected = expected_tag[1].children
            end

            -- actual
            local actual_tag = M._parse_tag_info(
                lines,
                TestResultType.ActualStart,
                TestResultType.ActualEnd
            )

            if #actual_tag > 0 then
                result.actual = actual_tag[1].children
            end

            -- stack trace
            local trace_tag = M._parse_tag_info(
                lines,
                TestResultType.TraceStart,
                TestResultType.TraceEnd
            )

            local trace = trace_tag[1].children

            -- There is a new line left in the stack trace
            if trace[#trace] == '' then
                trace[#trace] = nil
            end

            result.trace = trace_tag[1].children
        end

        return result
    end

    return M
end

return TestResultParser
