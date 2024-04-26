-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    autocmds = {
      mdindent = {
        event = "BufEnter",
        pattern = "*.md",
        group = "mdindent",
        callback = function()
          -- TODO: does this work??
          local function setindent(indent)
            vim.bo.expandtab = (indent > 0)
            indent = math.abs(indent)
            vim.bo.tabstop = indent
            vim.bo.softtabstop = indent
            vim.bo.shiftwidth = indent
            require("guess-indent").set_from_buffer()
          end

          local function indenter(indent)
            print("asdf")
            vim.loop.new_timer():start(200, 0, vim.schedule_wrap(function() setindent(indent) end))
          end

          indenter(2)
        end,
      }
    },
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        scrolloff = 6,
        sidescrolloff = 6,
        cursorcolumn = true,
        -- relativenumber = true, -- sets vim.opt.relativenumber
        -- number = true, -- sets vim.opt.number
        -- spell = false, -- sets vim.opt.spell
        -- signcolumn = "auto", -- sets vim.opt.signcolumn to auto
        -- wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- NORMAL MODE
      n = {
        ["<C-e>"]      = { "<cmd> Neotree reveal toggle <CR>", desc = "   toggle neotree" },
        ["<C-TAB>"]    = { "<cmd> bnext <CR>", desc = "  cycle next buffer" },
        ["<C-S-Tab>"]  = { "<cmd> bprev <CR>", desc = "  cycle prev buffer" },
        ["ga"]         = { "<c-a>", desc = "increment" },
        ["gx"]         = { "<c-x>", desc = "decrement" },
        ["<C-f>"]      = { "<cmd> Telescope find_files hidden=true<CR>", desc = "  find files" },
        ["<C-q>"]      = { "<cmd>lua require('bufdelete').bufdelete(0, false)<cr>", desc = "close buffer" },
        ["<C-x>"]      = { "<cmd>lua require('plugins.custom.tmux_sessionizer').find()<cr>", desc = "tmux-sessionizer" },
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
        -- ["<leader>Db"] = false,
        -- ["<leader>DB"] = false,
        -- ["<leader>Dc"] = false,
        -- ["<leader>Di"] = false,
        -- ["<leader>Do"] = false,
        -- ["<leader>DO"] = false,
        -- ["<leader>Dq"] = false,
        -- ["<leader>DQ"] = false,
        -- ["<leader>Dp"] = false,
        -- ["<leader>Dr"] = false,
        -- ["<leader>DR"] = false,
        -- ["<leader>Du"] = false,
        -- ["<leader>Dh"] = false,
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
      -- COMMAND MODE
      c = {},
      -- TERMINAL MODE
      t = {}
    },
  },
}
