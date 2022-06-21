local class = require('pl.class')
local Popup = require('nui.popup')
local event = require('nui.utils.autocmd').event
local Shortcut = require('nvim.utils.nvim.shortcut')
local TestStatus = require('nvim.utils.dap.java.test.test-status')
local TestEventType = require('nvim.utils.dap.java.test.test-event-type')
local Buffer = require('nvim.utils.ui.buffer')
local Highlighter = require('nvim.utils.nvim.highlighting.highlighter')
local TestHighlightGroups = require('nvim.utils.ui.test.test-highlight-groups')

local v = vim
local api = v.api

local highlighter = Highlighter:new():add(TestHighlightGroups)

local popup = Popup({
    enter = true,
    focusable = true,
    border = {
        style = 'rounded',
        highlight = 'FloatBorder',
    },
    position = '50%',
    size = {
        width = '60%',
        height = '60%',
    },
    buf_options = {
        modifiable = true,
        readonly = false,
    },
    win_options = {
        foldmethod = 'indent',
        foldlevel = 0,
    },
})

local M = class()

function M:_init(test_result_sub)
    self.results = {}

    test_result_sub.add_listener(TestEventType.COMPLETE, function(...)
        self:_on_test_complete(...)
    end)
end

function M:show()
    popup:mount()

    -- remove the window on exit
    popup:on(event.BufLeave, function()
        popup:unmount()
    end)

    Shortcut()
        :mode('n')
        :options()
        :buffer(popup.bufnr)
        :noremap()
        :next()
        :keymaps({ { '<cr>', 'zA' }, { 'o', 'zA' } })

    local buffer_ui = Buffer({
        buffer = popup.bufnr,
    })

    local line_count = api.nvim_buf_line_count(popup.bufnr)
    local lines = {}

    for _, result in ipairs(self.results) do
        for _, line in ipairs(result) do
            table.insert(lines, line)
        end
    end

    highlighter:register_highlights()
    buffer_ui:render(lines, line_count - 1, line_count)
end

function M:_on_test_complete(result)
    local parsed_lines = self._get_buffer_lines(result)
    table.insert(self.results, parsed_lines)
end

function M._get_buffer_lines(test_case_result)
    local status
    local lines = {}

    local cls = test_case_result.class
    local name = test_case_result.name

    if test_case_result.status == TestStatus.PASS then
        status = {
            text = string.format(' %s  %s', cls, name),
            highlight_group = TestHighlightGroups.TestPassed.name,
            foldlevel = 1,
        }
    elseif test_case_result.status == TestStatus.FAIL then
        status = {
            text = string.format(' %s  %s', cls, name),
            highlight_group = TestHighlightGroups.TestError.name,
            foldlevel = 1,
        }
    end

    table.insert(lines, status)

    if test_case_result.trace then
        for _, line in ipairs(test_case_result.trace) do
            table.insert(lines, {
                text = '\t' .. line,
                highlight_group = TestHighlightGroups.TestError.name,
                foldlevel = 1,
            })
        end
    end

    return lines
end

return M
