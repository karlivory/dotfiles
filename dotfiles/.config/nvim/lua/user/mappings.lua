return {
  -- NORMAL MODE
  n = {
    -- Buffers
    ["<c-e>"]     = { "<cmd> Neotree reveal toggle <CR>", desc = "   toggle neotree" },
    ["<c-TAB>"]   = { "<cmd> BufferLineCycleNext <CR>", desc = "  cycle next buffer" },
    ["<c-S-Tab>"] = { "<cmd> BufferLineCyclePrev <CR>", desc = "  cycle prev buffer" },
    ["ga"]        = { "<c-a>", desc = "increment" },
    ["gx"]        = { "<c-x>", desc = "decrement" },
    -- telescope mappings
    ["<c-f>"]     = { "<cmd> Telescope find_files hidden=true<CR>", desc = "  find files" },
    -- kmap("n", "<c-q>",          "<cmd>bd<cr>", "close buffer")
    -- kmap("n", "<c-c>",          "<cmd> %y+ <CR>", "  copy whole file to clipboard")
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
    -- Move across buffers
    ["<c-h>"] = { "<c-w>", desc = "Delete previous word" },
    [","]     = { ",<C-g>u", desc = "undo breakpoints" },
    ["."]     = { ".<c-g>u", desc = "undo breakpoints" },
    ["!"]     = { "!<c-g>u", desc = "undo breakpoints" },
    ["?"]     = { "?<c-g>u", desc = "undo breakpoints" },
    -- ["<c-y>",          "<cmd>lua require('nvim2.utils').better_escape()<CR>", "  no highlight")
  },

  -- VISUAL MODE
  v = {
    -- Move across buffers
    ["ga"] = { "g<c-a>", desc = "increment (multi)" },
    ["gx"] = { "g<c-x>", desc = "increment (multi)" },

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
