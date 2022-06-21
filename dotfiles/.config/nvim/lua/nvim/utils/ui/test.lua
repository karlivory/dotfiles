local Component = require('nvim.utils.ui.component')
local React = require('nvim.utils.ui.react')

local Root = Component()
local Greet = Component()
local Footer = Component()

function Greet:render()
    return 'Hello'
end

function Footer:render()
    return 'Footer'
end

function Root:render()
    return string.format(
        'First Name: %s Last Name: %s',
        self.props.fname,
        self.props.lname
    )
end

local components = React.create_element(
    Root,
    { fname = 'Srinesh', lname = 'Nisala' },
    React.create_element(Greet, nil, nil),
    React.create_element(Footer, nil, nil)
)

Log.ins(components)
Log.ins(components:render())
