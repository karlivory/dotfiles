local React = {}

function React.create_element(component, props, ...)
    local children = { ... }

    for _, child in ipairs(children) do
        child:set_parent(component)
    end

    return component:set_props(props):set_children(children)
end

return React
