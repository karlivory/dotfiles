local class = require('pl.class')

local v = vim
local api = v.api

local M = class()

function M:_init(options)
    self.buffer = options.buffer
    self.highlights = {}
end

-- Render the passed list of content to the buffer
-- IF the start and end range is given, this replaces the content in the range
-- IF the range is not given, this replaces the entire buffer
function M:render(line_info, startLine, endLine)
    startLine = startLine or 0
    endLine = endLine or api.nvim_buf_line_count(self.buffer)

    local lines = self:_register_highlights_and_get_lines(line_info)

    api.nvim_buf_set_lines(self.buffer, startLine, endLine, true, lines)

    self:_set_highlights()

    return { startLine, #lines }
end

function M:append(lines)
    local startLine = api.nvim_buf_line_count(self.buffer)

    self:render(lines, startLine, startLine + 1)
end

function M:_set_highlights()
    for _, highlight in ipairs(self.highlights) do
        vim.fn.matchaddpos(highlight.highlight_group, highlight.range)
    end
end

function M:_register_highlights_and_get_lines(line_info)
    local lines = {}

    for index, line in ipairs(line_info) do
        local line_text = ''
        local line_no = index

        if #line > 0 then
            local column = 1

            for _, segment in ipairs(line) do
                table.insert(self.highlights, {
                    range = { line_no, column, #segment.text },
                    highlight_group = segment.highlight_group,
                })

                column = column + #segment.text
                line_text = line_text .. segment.text
            end
        else
            local column = 1

            table.insert(self.highlights, {
                range = { line_no },
                highlight_group = line.highlight_group,
            })

            column = column + #line.text
            line_text = line.text
        end

        table.insert(lines, line_text)
    end

    return lines
end

return M
