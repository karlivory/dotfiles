local QueryManager = require('nvim.utils.treesitter.query-manager')

local qm = QueryManager('java')

local M = {}

function M.setup()
    qm:add_query(
        'TestMethods',
        [[
        (class_declaration body:
            (class_body (method_declaration
                (modifiers
                    (marker_annotation
                        name: (identifier) @annotation (#eq? @annotation "Test")))
                        name: (identifier) @method (#offset! @method))))
        ]]
    )

    qm:add_query(
        'Methods',
        [[
        (class_declaration
            body: (class_body (
                (method_declaration
                    name: (identifier) @method (#offset! @method)))))
        ]]
    )
end

return M
