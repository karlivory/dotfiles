local plugins = {

   ["nvim-lua/plenary.nvim"] = {},
   ["lewis6991/impatient.nvim"] = {},
   ["wbthomason/packer.nvim"] = {},
   ["NvChad/extensions"] = {},
   ["ellisonleao/gruvbox.nvim"] = {},
   ["catppuccin/nvim"] = {},

   ["kyazdani42/nvim-web-devicons"] = {
      config = function()
         require "nvim.plugins.configs.icons"
      end,
   },

   ["SmiteshP/nvim-gps"] = {
      event = "CursorMoved",
      config = function()
         require "nvim.plugins.configs.gps"
      end,
   },

   ["akinsho/bufferline.nvim"] = {
      tag = "v2.*",
      after = "nvim-web-devicons",
      config = function()
         require "nvim.plugins.configs.bufferline"
      end,
   },

   ["lukas-reineke/indent-blankline.nvim"] = {
      event = "BufRead",
      config = function()
         require("nvim.plugins.configs.others").blankline()
      end,
   },

   ["NvChad/nvim-colorizer.lua"] = {
      event = "BufRead",
      config = function()
         require("nvim.plugins.configs.others").colorizer()
      end,
   },

   ["nvim-treesitter/nvim-treesitter"] = {
      event = { "BufRead", "BufNewFile" },
      run = ":TSUpdate",
      config = function()
         require "nvim.plugins.configs.treesitter"
      end,
   },

   -- git stuff
   ["lewis6991/gitsigns.nvim"] = {
      opt = true,
      config = function()
         require("nvim.plugins.configs.others").gitsigns()
      end,
      setup = function()
         require("nvim.core.utils").packer_lazy_load "gitsigns.nvim"
      end,
   },

   -- lsp stuff
   ["williamboman/nvim-lsp-installer"] = {
      opt = true,
      setup = function()
         require("nvim.core.utils").packer_lazy_load "nvim-lsp-installer"
         -- reload the current file so lsp actually starts for it
         vim.defer_fn(function()
            vim.cmd 'if &ft == "packer" | echo "" | else | silent! e %'
         end, 0)
      end,
   },

   ["neovim/nvim-lspconfig"] = {
      after = "nvim-lsp-installer",
      module = "lspconfig",
      config = function()
         require "nvim.plugins.configs.lsp_installer"
         require "nvim.plugins.configs.lspconfig"
      end,
   },

   ["ray-x/lsp_signature.nvim"] = {
      after = "nvim-lspconfig",
      config = function()
         require("nvim.plugins.configs.others").signature()
      end,
   },

   ["smjonas/inc-rename.nvim"] = {
     config = function()
       require("inc_rename").setup()
     end,
   },

   -- load luasnips + cmp related in insert mode only
   ["rafamadriz/friendly-snippets"] = {
      module = "cmp_nvim_lsp",
      event = "InsertEnter",
   },

   ["hrsh7th/nvim-cmp"] = {
      after = "friendly-snippets",
      config = function()
         require "nvim.plugins.configs.cmp"
      end,
   },

   ["L3MON4D3/LuaSnip"] = {
      -- wants = "friendly-snippets",
      after = "nvim-cmp",
      config = function()
         require("nvim.plugins.configs.others").luasnip()
      end,
   },

   ["saadparwaiz1/cmp_luasnip"] = {
      after = "LuaSnip",
   },

   ["hrsh7th/cmp-nvim-lua"] = {
      after = "cmp_luasnip",
   },

   ["hrsh7th/cmp-nvim-lsp"] = {
      after = "cmp-nvim-lua",
   },

   ["hrsh7th/cmp-buffer"] = {
      after = "cmp-nvim-lsp",
   },

   ["hrsh7th/cmp-path"] = {
      after = "cmp-buffer",
   },

   -- misc plugins
   ["windwp/nvim-autopairs"] = {
      after = "nvim-cmp",
      config = function()
         require("nvim.plugins.configs.others").autopairs()
      end,
   },

   ["numToStr/Comment.nvim"] = {
      module = "Comment",
      keys = { "gc", "gb" },
      config = function()
         require("nvim.plugins.configs.others").comment()
      end,
   },

   -- file managing, picker etc
   ["kyazdani42/nvim-tree.lua"] = {
      ft = "alpha",
      cmd = { "NvimTreeToggle", "NvimTreeFocus" },
      config = function()
         require "nvim.plugins.configs.nvimtree"
      end,
   },

   ["nvim-telescope/telescope.nvim"] = {
      cmd = "Telescope",
      config = function()
         require "nvim.plugins.configs.telescope"
      end,
   },

   ["folke/which-key.nvim"] = {
      opt = true,
      setup = function()
         require("nvim.core.utils").packer_lazy_load "which-key.nvim"
      end,
      config = function()
         require "nvim.plugins.configs.whichkey"
      end,
   },

-- Debug
  ["mfussenegger/nvim-dap"] = {
    ft = {"java", "scala"},
    config = function()
      require "nvim.plugins.configs.nvim_dap"
    end
  },
  ["rcarriga/nvim-dap-ui"] = {
    -- after = {"nvim-dap"},
    ft = {"java", "scala"},
    config = function()
      require "nvim.plugins.configs.nvim_dap_ui"
    end
  },
  ["theHamsta/nvim-dap-virtual-text"] = {
    -- after = {"nvim-dap-ui"},
    ft = {"java"},
    config = function()
      require "nvim.plugins.configs.nvim_dap_virtual_text"
    end
  },

   -- JAVA stuff
   ["mfussenegger/nvim-jdtls"] = {},

   -- SCALA stuff
   ["scalameta/nvim-metals"] = {
     -- after = {"nvim-dap"},
     requires = { "nvim-lua/plenary.nvim" },
     ft = "scala",
     config = function()
       require "nvim.plugins.configs.nvim_metals"
     end,
   }
}

require("nvim.core.packer").run(plugins)
