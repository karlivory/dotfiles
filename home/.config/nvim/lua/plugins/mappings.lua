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
          ["<C-Q>"] = { "<cmd>lua require('bufdelete').bufdelete(0, false)<cr>", desc = "close buffer" },
          ["<C-X>"] = {
            "<cmd>lua require('plugins.custom.tmux_sessionizer').find()<cr>",
            desc = "tmux-sessionizer",
          },
          ["<C-C>"] = { "mZggVGy`Z", desc = "  yank whole file" },
          ["<leader>z"] = { "<cmd> ZenMode <CR>", desc = "toggle Zen mode" },
          -- TELESCOPE
          ["<C-F>"] = { "<cmd> Telescope find_files hidden=true<CR>", desc = "  find files" },
          ["<Leader>fq"] = { "<cmd> Telescope quickfix <CR>", desc = "quickfix" },
          ["<Leader>fQ"] = { "<cmd> Telescope quickfixhistory <CR>", desc = "quickfixhistory" },
          ["<Leader>fd"] = { "<cmd> Telescope diagnostics <CR>", desc = "diagnostics (hint: press <c-l>)" },
          ["<Leader>fD"] = { "<cmd> Telescope diagnostics bufnr=0 <CR>", desc = "diagnostics in current buffer" },
          ["gr"] = { "<cmd> Telescope lsp_references <CR>", desc = "quickfix" },
          ["gi"] = { "<cmd> Telescope lsp_implementations <CR>", desc = "quickfix" },
          ["gd"] = { "<cmd> Telescope lsp_definitions <CR>", desc = "quickfix" },
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
          ["<C-F>"] = { "<cmd> Telescope find_files hidden=true<CR>", desc = "  find files" },
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
