local EventType = {
    -- Called when ls is attached to buffer but only the first time
    SERVER_READY = 1,

    -- Called when ls is attached to a buffer every single time
    ATTACH = 2,
}

return EventType
