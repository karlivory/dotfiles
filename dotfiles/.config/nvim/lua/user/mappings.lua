return {
  -- NORMAL MODE
  n = {
    -- Buffers
    ["<C-e>"]      = { "<cmd> Neotree reveal toggle <CR>", desc = "   toggle neotree" },
    ["<C-TAB>"]    = { "<cmd> BufferLineCycleNext <CR>", desc = "  cycle next buffer" },
    ["<C-S-Tab>"]  = { "<cmd> BufferLineCyclePrev <CR>", desc = "  cycle prev buffer" },
    ["ga"]         = { "<c-a>", desc = "increment" },
    ["gx"]         = { "<c-x>", desc = "decrement" },
    ["<C-f>"]      = { "<cmd> Telescope find_files hidden=false<CR>", desc = "  find files" },
    ["<C-q>"]      = { "<cmd>bd<cr>", desc = "close buffer" },
    ["<C-x>"]      = { "<cmd>lua require('user.plugins.custom.tmux_sessionizer').find()<cr>", desc = "tmux-sessionizer" },
    ["<C-c>"]      = { "<cmd> %y+ <CR>", desc = "  copy whole file to clipboard" }, -- why does this print to messages?
    -- telescope mappings
    ["<leader>fk"] = { "<cmd> Telescope keymaps <CR>", desc = " find in keymaps" },
    ["<leader>fq"] = { "<cmd> Telescope quickfix <CR>", desc = "quickfix" },
    ["<leader>fQ"] = { "<cmd> Telescope quickfixhistory <CR>", desc = "quickfixhistory" },
    ["<leader>fd"] = { "<cmd> Telescope diagnostics <CR>", desc = "diagnostics (hint: press <c-l>)" },
    ["<leader>fD"] = { "<cmd> Telescope diagnostics bufnr=0 <CR>", desc = "diagnostics in current buffer" },
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
    ["<leader>R"]  = { "<cmd> AstroReload <cr>", desc = "Reload nvim config" },




    -- unbind useless junk (unused binds are visual clutter)
    ["<leader>w"] = false,
    ["<leader>c"] = false,
    ["<leader>C"] = false,
    ["<leader>q"] = false,
    ["<leader>/"] = false,
    ["<leader>o"] = false,
    ["<leader>e"] = false,
    ["<leader>h"] = false,
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

    -- kmap("n", "<c-x>",          "<cmd>lua require('nvim2.plugins.custom.tmux_sessionizer').find()<cr>", "tmux-sessionizer")
    -- kmap("n", "<c-f>",          "<cmd> Telescope find_files hidden=true<CR>", "  find files")
    -- kmap("n", "<leader>cm",     "<cmd> Telescope git_commits <CR>", "   git commits")
    -- kmap("n", "<leader>fh",     "<cmd> Telescope help_tags <CR>", "  help page")
    -- kmap("n", "<leader>fo",     "<cmd> Telescope buffers <CR>", " find open buffers")
    -- kmap("n", "<leader>fj",     "<cmd> Telescope jumplist <CR>")
    -- kmap("n", "<leader>ft",     "<cmd> Telescope treesitter <CR>")
    -- kmap("n", "<leader>fw",     "<cmd> Telescope live_grep<CR>", "   live grep")
    -- ["<M-S-CR>"]  = { "<cmd>BufferLineCyclePrev<cr>" },
    -- ["<M-S-Tab>"] = { "<cmd>BufferLineCycleNext<cr>" },
    --
    -- -- Movement across windows
    -- ["<C-m>"] = { "<C-w>W", desc = "Move focus to the previous window" },
    -- ["<C-i>"] = { "<C-w>w", desc = "Move focus to the next window" },
    --
    -- -- Smooth PageUp/Down
    -- -- ["<PageUp>"]   = { "<C-b>" },
    -- -- ["<PageDown>"] = { "<C-f>" },
    -- ["<PageUp>"]   = { "<C-u>" },
    -- ["<PageDown>"] = { "<C-d>" },
    --
    -- -- Move across wrapped lines
    -- ["j"]      = { "gj" },
    -- ["k"]      = { "gk" },
    -- ["<Up>"]   = { "g<Up>" },
    -- ["<Down>"] = { "g<Down>" },
    --
    -- -- Easy-Align
    -- ["ga"] = { "<Plug>(EasyAlign)", desc = "Easy Align" },
    --
    -- -- Better increment/decrement
    -- ["-"] = { "<c-x>", desc = "Descrement number" },
    -- ["+"] = { "<c-a>", desc = "Increment number" },
    --
    -- -- Suppress yanking on operations
    -- ["d"] = { "\"_d" },
    -- ["x"] = { "\"_x" },
    -- ["c"] = { "\"_c" },

  },

  -- INSERT MODE
  i = {
    ["<c-h>"] = { "<c-w>", desc = "Delete previous word" },
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
    ["<c-TAB>"]   = { "<cmd> BufferLineCycleNext <CR>", desc = "  cycle next buffer" },
    ["<c-S-Tab>"] = { "<cmd> BufferLineCyclePrev <CR>", desc = "  cycle prev buffer" },
    ["<c-f>"]     = { "<cmd> Telescope find_files hidden=false<CR>", desc = "  find files" },

    -- Suppress yanking on operations
    -- ["d"] = { "\"_d" },
    -- ["p"] = { "\"_dP" },
    -- ["c"] = { "\"_c" },
  },

  -- COMMAND MODE
  c = {
  },
  -- TERMINAL MODE
  t = {
  },
}
