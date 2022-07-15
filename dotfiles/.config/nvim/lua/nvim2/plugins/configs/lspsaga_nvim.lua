local saga = require("lspsaga")

-- use custom config
saga.init_lsp_saga({
  -- "single" | "double" | "rounded" | "bold" | "plus"
  border_style = "single",
  -- when cursor in saga window you config these to move
  move_in_saga = { prev = "<C-p>", next = "<C-n>" },
  code_action_icon = "💡",
  -- if true can press number to execute the codeaction in codeaction window
  code_action_num_shortcut = true,
  -- same as nvim-lightbulb but async
  code_action_lightbulb = {
    enable = false,
    sign = true,
    sign_priority = -10000,
    virtual_text = false,
  },
  -- preview lines of lsp_finder and definition preview
  max_preview_lines = 10,
  code_action_keys = {
    quit = "<C-c>",
    exec = "<CR>",
  },
  rename_action_quit = "<C-c>",
  definition_preview_icon = "  ",
})
