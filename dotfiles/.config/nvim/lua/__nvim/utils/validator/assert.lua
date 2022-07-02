local class = require('pl.class')
local List = require('pl.List')

local Assert = class()

function Assert.get_message(message)
    return message .. '\n' .. debug.traceback()
end

function Assert.is_string(_, value, message)
    message = Assert.get_message(
        message or ('expected value to be a string but passed ' .. type(value))
    )
    assert(type(value) == 'string', message)
end

function Assert.is_number(_, value, message)
    message = Assert.get_message(
        message or ('expected value to be a number but passed ' .. type(value))
    )
    assert(type(value) == 'number', message)
end

function Assert.is_function(_, value, message)
    message = Assert.get_message(
        message
            or ('expected value to be a function but passed ' .. type(value))
    )
    assert(type(value) == 'function', message)
end

function Assert.is_boolean(_, value, message)
    message = Assert.get_message(
        message or ('expected value to be a boolean but passed ' .. type(value))
    )
    assert(type(value) == 'boolean', message)
end

function Assert.is_table(_, value, message)
    message = Assert.get_message(
        message or ('expected value to be a table but passed ' .. type(value))
    )
    assert(type(value) == 'table', message)
end

function Assert.is_nil(_, value, message)
    message = Assert.get_message(
        message or ('expected value to be a nil but passed ' .. type(value))
    )
    assert(type(value) == 'nil', message)
end

function Assert.is_true(_, value, message)
    message = Assert.get_message(
        message
            or ('expected value to be a true but passed ' .. tostring(value))
    )
    assert(value == true, message)
end

function Assert.is_false(_, value, message)
    message = Assert.get_message(
        message
            or ('expected value to be a false but passed ' .. tostring(value))
    )
    assert(value == false, message)
end

function Assert.is_truthy(_, value, message)
    message = Assert.get_message(
        message
            or ('expected value to be a truthy but passed ' .. tostring(value))
    )
    assert(value, message)
end

function Assert.is_falsy(_, value, message)
    message = Assert.get_message(
        message
            or ('expected value to be a falsy but passed ' .. tostring(value))
    )
    assert(not value, message)
end

function Assert.is_instance_of(_, cls, value, message, class_name)
    message = class_name
        and Assert.get_message(
            ('expected value to be an instance of ' .. class_name)
                or 'expected value to be an instance of the passed class'
        )
    assert(cls:class_of(value), message)
end

function Assert.is_not_instance_of(_, cls, value, message, class_name)
    message = class_name
        and Assert.get_message(
            ('expected value not to be an instance of ' + class_name)
                or 'expected value not to be an instance of the passed class'
        )
    assert(not (cls:class_of(value)), message)
end

function Assert.is_primitive(_, value, message)
    message = Assert.get_message(
        message or ('expected value to a primitive but passed ' .. type(value))
    )

    local allowed_types = List({ 'number', 'string', 'boolean' })
    assert(allowed_types:contains(type(value)), message)
    type()
end

function Assert.is_instance_of_any(_, classes, value, message, class_name)
    local matching_classes = List(classes):filter(function(cls)
        return cls:class_of(value)
    end)

    local has_any = matching_classes:len() > 0

    message = class_name
        and Assert.get_message(
            ('expected value to be an instance of ' .. class_name)
                or 'expected value to be an instance of the passed class'
        )

    assert(has_any, message)
end

return Assert
