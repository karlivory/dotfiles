local function map_join(map)
    local list = {}

    for k, v in pairs(map) do
        table.insert(list, k .. '=' .. v)
    end

    return table.concat(list, ' ');
end

local function HighlightGroups(highlights)
    local highlight_groups = {}

    for name, colors in pairs(highlights) do
        highlight_groups[name] = {
            name = name,
            colors = map_join(colors),
        }
    end

    return highlight_groups
end

return HighlightGroups
