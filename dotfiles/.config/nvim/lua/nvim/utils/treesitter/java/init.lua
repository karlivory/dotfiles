local ts = require('nvim.utils.treesitter')
local q = vim.treesitter.query

local M = {}

--[[
-- Returns test methods in the current file
-- @returns { class_names = { method1, method2, method3 } } test methods in the
-- current file
--]]
function M.get_test_methods(buffer)
    buffer = buffer or API.nvim_get_current_buf()

    local query = [[
      (
        (import_declaration
          (scoped_identifier) @import (#any-of? @import
            "org.junit.jupiter.api.Test"))
        (class_declaration
          body: (class_body (
            (method_declaration
              (modifiers
                (marker_annotation
                  name: (identifier) @annotation (#eq? @annotation "Test")))
              name: (identifier) @method (#offset! @method)))))
      )
    ]]

    local match_iter = ts.get_query_matches(buffer, 'java', query)

    local methods = {}

    for _, match, metadata in match_iter do
        table.insert(methods, {
            name = q.get_node_text(match[3], buffer),
            range = metadata.content[1],
        })
    end

    return methods
end

--[[
-- Returns methods in the current file
-- @returns { class_names = { method1, method2, method3 } } methods in the
-- current file
--]]
function M.get_methods(buffer)
    buffer = buffer or API.nvim_get_current_buf()

    local query = [[
      (class_declaration
        body: (class_body (
          (method_declaration
            name: (identifier) @method (#offset! @method)))))
    ]]

    local match_iter = ts.get_query_matches(buffer, 'java', query)

    local methods = {}

    for _, match, metadata in match_iter do
        table.insert(methods, {
            name = q.get_node_text(match[1], buffer),
            range = metadata.content[1],
        })
    end

    return methods
end

return M
