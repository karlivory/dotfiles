local class = require('pl.class')
local ts = vim.treesitter

local M = class()

-- M:new creates new query manager
-- @param { string } language to manage queries
function M:_init(language)
    self.language = language
end

-- M:add_query adds a new query to current language tree
-- @param { string } name used to retrieve the query
-- @param { string } query to save
function M:add_query(name, query)
    ts.set_query(self.language, name, query)
end

-- M:get_matches_iter returns matched nodes iter by given query
-- @param { string } name of the query
-- @param { number } buffer to evaluate agaist. Default to current buffer
function M:get_matches_iter(name, buffer)
    buffer = buffer or 0

    local root = ts.get_parser(buffer, self.language):parse()[1]:root()
    local query = ts.get_query(name, self.language)

    return query:iter_matches(root, buffer)
end

return M
