return {
  -- NORMAL MODE
  n = {
    ["<C-e>"]      = { "<cmd> Neotree reveal toggle <CR>", desc = "   toggle neotree" },
    ["<C-TAB>"]    = { "<cmd> bnext <CR>", desc = "  cycle next buffer" },
    ["<C-S-Tab>"]  = { "<cmd> bprev <CR>", desc = "  cycle prev buffer" },
    ["ga"]         = { "<c-a>", desc = "increment" },
    ["gx"]         = { "<c-x>", desc = "decrement" },
    ["<C-f>"]      = { "<cmd> Telescope find_files hidden=true<CR>", desc = "  find files" },
    ["<C-q>"]      = { "<cmd>lua require('bufdelete').bufdelete(0, false)<cr>", desc = "close buffer" },
    ["<C-x>"]      = { "<cmd>lua require('user.plugins.custom.tmux_sessionizer').find()<cr>", desc = "tmux-sessionizer" },
    ["<C-c>"]      = { "mZggVGy`Z", desc = "  yank whole file" }, -- why does this print to messages?
    ["<leader>z"]  = { "<cmd> ZenMode <CR>", desc = "toggle Zen mode" },
    -- TELESCOPE
    ["<leader>fk"] = { "<cmd> Telescope keymaps <CR>", desc = " find in keymaps" },
    ["<leader>fq"] = { "<cmd> Telescope quickfix <CR>", desc = "quickfix" },
    ["<leader>fQ"] = { "<cmd> Telescope quickfixhistory <CR>", desc = "quickfixhistory" },
    ["<leader>fd"] = { "<cmd> Telescope diagnostics <CR>", desc = "diagnostics (hint: press <c-l>)" },
    ["<leader>fD"] = { "<cmd> Telescope diagnostics bufnr=0 <CR>", desc = "diagnostics in current buffer" },
    -- LSP actions
    ["<leader>a"]  = { function() vim.lsp.buf.code_action() end, desc = "Code action" },
    -- DEBUGGING - copied from lua/core/mappings.lua
    ["<leader>db"] = { function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint (F9)" },
    ["<leader>dB"] = { function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoints" },
    ["<leader>dc"] = { function() require("dap").continue() end, desc = "Start/Continue (F5)" },
    ["<leader>di"] = { function() require("dap").step_into() end, desc = "Step Into (F11)" },
    ["<leader>do"] = { function() require("dap").step_over() end, desc = "Step Over (F10)" },
    ["<leader>dO"] = { function() require("dap").step_out() end, desc = "Step Out (S-F11)" },
    ["<leader>dq"] = { function() require("dap").close() end, desc = "Close Session" },
    ["<leader>dQ"] = { function() require("dap").terminate() end, desc = "Terminate Session (S-F5)" },
    ["<leader>dp"] = { function() require("dap").pause() end, desc = "Pause (F6)" },
    ["<leader>dr"] = { function() require("dap").restart_frame() end, desc = "Restart (C-F5)" },
    ["<leader>dR"] = { function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    ["<leader>du"] = { function() require("dapui").toggle() end, desc = "Toggle Debugger UI" },
    ["<leader>dh"] = { function() require("dap.ui.widgets").hover() end, desc = "Debugger Hover" },
    ["<leader>gi"] = { '<cmd> silent lua require("guess-indent").set_from_buffer() <CR>', desc = "" },
    ["<leader>y"]  = { function() require("yaml-companion").open_ui_select() end, desc = "" },
    -- unbind default AstroNvim keybinds
    ["<TAB>"]      = false,
    ["<leader>w"]  = false,
    ["<leader>c"]  = false,
    ["<leader>C"]  = false,
    ["<leader>q"]  = false,
    ["<leader>/"]  = false,
    ["<leader>o"]  = false,
    ["<leader>e"]  = false,
    ["<leader>h"]  = false,
    ["<leader>Db"] = false,
    ["<leader>DB"] = false,
    ["<leader>Dc"] = false,
    ["<leader>Di"] = false,
    ["<leader>Do"] = false,
    ["<leader>DO"] = false,
    ["<leader>Dq"] = false,
    ["<leader>DQ"] = false,
    ["<leader>Dp"] = false,
    ["<leader>Dr"] = false,
    ["<leader>DR"] = false,
    ["<leader>Du"] = false,
    ["<leader>Dh"] = false,
    -- -- Suppress yanking on operations
    ["c"]          = { "\"_c" },
    ["C"]          = { "\"_C" },
    -- ["d"] = { "\"_d" },
    -- ["x"] = { "\"_x" },
  },
  -- INSERT MODE
  i = {
    ["<c-h>"] = { "<c-w>", desc = "Delete previous word" },
    ["<C-s>"] = { "<cmd>w!<cr>", desc = "Save" },
    -- ["<C-v>"] = { "<C-o>p", desc = "paste" },
    [","]     = { ",<C-g>u", desc = "undo breakpoints" },
    ["."]     = { ".<c-g>u", desc = "undo breakpoints" },
    ["!"]     = { "!<c-g>u", desc = "undo breakpoints" },
    ["?"]     = { "?<c-g>u", desc = "undo breakpoints" },
  },
  -- VISUAL MODE
  v = {
    ["ga"]        = { "g<c-a>", desc = "increment (multi)" },
    ["gx"]        = { "g<c-x>", desc = "increment (multi)" },
    ["<c-e>"]     = { "<cmd> Neotree reveal toggle <CR>", desc = "   toggle neotree" },
    ["<c-TAB>"]   = { "<cmd> bnext <CR>", desc = "  cycle next buffer" },
    ["<c-S-Tab>"] = { "<cmd> bprev <CR>", desc = "  cycle prev buffer" },
    ["<c-f>"]     = { "<cmd> Telescope find_files hidden=true<CR>", desc = "  find files" },
    -- Suppress yanking on operations
    ["p"]         = { "\"_dp" },
    ["P"]         = { "\"_dP" },
    ["c"]         = { "\"_c" },
    -- ["d"] = { "\"_d" },
  },
  -- COMMAND MODE
  c = {
  },
  -- TERMINAL MODE
  t = {
  },
}
