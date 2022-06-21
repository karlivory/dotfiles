local Shortcut = require('nvim.utils.nvim.shortcut')
local CmdString = require('nvim.utils.nvim.command-string')
local n = CmdString.get_normal_cmd_string

Shortcut():mode('i'):options():noremap():next():keymaps({
    ----------------------------------------------------------------------
    --                           CURSOR MOVE                            --
    ----------------------------------------------------------------------
    -- put a semicolon EOL and go to next line
    { '<c-;>', n('A;') },

    -- add new line in insert mode
    { '<c-o>', n('o') },

    -- go to end of the line
    { '<c-e>', n('A') },

    -- go to beginning of the line
    { '<c-a>', n('I') },

    ----------------------------------------------------------------------
    --                          CUT COPY PASTE                          --
    ----------------------------------------------------------------------
    -- copy current line and paste next line
    { '<c-y>', n('yyp') },

    ----------------------------------------------------------------------
    --                              EDITOR                              --
    ----------------------------------------------------------------------
    { 'nn', '<esc>' },

    ----------------------------------------------------------------------
    --                              OTHER                               --
    ----------------------------------------------------------------------
    { '<tab>', '<tab>' },
})
