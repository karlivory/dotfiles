-- default mappings: https://docs.astronvim.com/mappings
return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        -- NORMAL MODE
        n = {
          ["<C-E>"] = { "<cmd> Neotree reveal toggle <CR>", desc = "   toggle neotree" },
          ["<C-TAB>"] = { "<cmd> bnext <CR>", desc = "  cycle next buffer" },
          ["<C-S-Tab>"] = { "<cmd> bprev <CR>", desc = "  cycle prev buffer" },
          ["ga"] = { "<c-a>", desc = "increment" },
          ["gx"] = { "<c-x>", desc = "decrement" },
          ["<C-Q>"] = {
            function() require("snacks.bufdelete").delete() end,
            -- "<cmd>lua require('bufdelete').bufdelete(0, false)<cr>",
            desc = "close buffer",
          },
          ["<C-X>"] = {
            function() require("plugins.custom.tmux_sessionizer").find() end,
            desc = "tmux-sessionizer",
          },
          ["<C-C>"] = { "mZggVGy`Z", desc = "  yank whole file" },
          ["<leader>z"] = {
            function() require("snacks.zen").zen() end,
            -- "<cmd> ZenMode <CR>",
            desc = "toggle Zen mode",
          },
          -- TELESCOPE
          ["<C-F>"] = {
            function() require("snacks.picker").files { hidden = true } end,
            desc = "  find files",
          },
          ["<Leader>fw"] = {
            function() require("snacks.picker").grep { hidden = true } end,
            desc = "Find words",
          },
          -- ["<Leader>fq"] = { "<cmd> Telescope quickfix <CR>", desc = "quickfix" },
          -- ["<Leader>fQ"] = { "<cmd> Telescope quickfixhistory <CR>", desc = "quickfixhistory" },
          ["<Leader>fd"] = {
            function() require("snacks.picker").diagnostics() end,
            desc = "diagnostics (hint: press <c-l>)",
          },
          ["<Leader>fD"] = {
            function() require("snacks.picker").diagnostics_buffer() end,
            desc = "diagnostics in current buffer",
          },
          ["gr"] = {
            function() require("snacks.picker").lsp_references() end,
            desc = "lsp: references",
          },
          ["gi"] = {
            function() require("snacks.picker").lsp_implementations() end,
            desc = "lsp: implementations",
          },
          ["gd"] = {
            function() require("snacks.picker").lsp_definitions() end,
            desc = "lsp: definitions",
          },
          -- LSP actions
          ["<Leader>a"] = { function() vim.lsp.buf.code_action() end, desc = "Code action" },
          -- unbind default AstroNvim keybinds
          ["<TAB>"] = false,
          ["<Leader>w"] = false,
          ["<Leader>c"] = false,
          ["<Leader>C"] = false,
          ["<Leader>q"] = false,
          ["<Leader>/"] = false,
          ["<Leader>o"] = false,
          ["<Leader>e"] = false,
          ["<Leader>h"] = false,
          ["<Leader>Db"] = false,
          ["<Leader>DB"] = false,
          ["<Leader>Dc"] = false,
          ["<Leader>Di"] = false,
          ["<Leader>Do"] = false,
          ["<Leader>DO"] = false,
          ["<Leader>Dq"] = false,
          ["<Leader>DQ"] = false,
          ["<Leader>Dp"] = false,
          ["<Leader>Dr"] = false,
          ["<Leader>DR"] = false,
          ["<Leader>Du"] = false,
          ["<Leader>Dh"] = false,
          -- -- Suppress yanking on operations
          ["c"] = { '"_c' },
          ["C"] = { '"_C' },
          -- ["d"] = { "\"_d" },
          -- ["x"] = { "\"_x" },
        },
        -- INSERT MODE
        i = {
          ["<C-H>"] = { "<c-w>", desc = "Delete previous word" },
          ["<C-S>"] = { "<cmd>w!<cr>", desc = "Save" },
          -- ["<C-v>"] = { "<C-o>p", desc = "paste" },
          [","] = { ",<C-g>u", desc = "undo breakpoints" },
          ["."] = { ".<c-g>u", desc = "undo breakpoints" },
          ["!"] = { "!<c-g>u", desc = "undo breakpoints" },
          ["?"] = { "?<c-g>u", desc = "undo breakpoints" },
        },
        -- VISUAL MODE
        v = {
          ["ga"] = { "g<c-a>", desc = "increment (multi)" },
          ["gx"] = { "g<c-x>", desc = "increment (multi)" },
          ["<C-E>"] = { "<cmd> Neotree reveal toggle <CR>", desc = "   toggle neotree" },
          ["<C-TAB>"] = { "<cmd> bnext <CR>", desc = "  cycle next buffer" },
          ["<C-S-Tab>"] = { "<cmd> bprev <CR>", desc = "  cycle prev buffer" },
          ["<C-F>"] = {
            function() require("snacks.picker").files { hidden = true } end,
            desc = "  find files",
          },
          -- Suppress yanking on operations
          ["p"] = { '"_dp' },
          ["P"] = { '"_dP' },
          ["c"] = { '"_c' },
          -- ["d"] = { "\"_d" },
        },
        -- COMMAND MODE
        c = {},
        -- TERMINAL MODE
        t = {},
      },
    },
  },
}
