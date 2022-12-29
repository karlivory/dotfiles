local base = {
  ["packer_nvim"] = { "wbthomason/packer.nvim" },
  ["plenary_nvim"] = { "nvim-lua/plenary.nvim" },
}

local common = {
  ["bufferline_nvim"] = { "akinsho/bufferline.nvim" },
  ["fidget_nvim"] = { "j-hui/fidget.nvim", event = "BufRead" },
  ["friendly_snippets"] = { "rafamadriz/friendly-snippets" },
  ["gitsigns_nvim"] = { "lewis6991/gitsigns.nvim", event = "BufRead" },
  ["impatient_nvim"] = { "lewis6991/impatient.nvim" },
  ["indent_blankline_nvim"] = { "lukas-reineke/indent-blankline.nvim", event = "BufRead" },
  ["lsp_signature_nvim"] = { "ray-x/lsp_signature.nvim", event = "BufRead" },
  ["luasnip"] = { "L3MON4D3/LuaSnip" },
  -- ["nvim_autopairs"] = { "windwp/nvim-autopairs", event = "BufRead" },
  ["nvim_colorizer_lua"] = { "norcalli/nvim-colorizer.lua", event = "BufRead" },
  ["nvim_comment"] = { "terrortylor/nvim-comment", event = "BufRead" },
  ["nvim_dap"] = { "mfussenegger/nvim-dap" },
  ["nvim_dap_ui"] = { "rcarriga/nvim-dap-ui" },
  ["nvim_dap_virtual_text"] = { "theHamsta/nvim-dap-virtual-text" },
  ["nvim_jdtls"] = { "mfussenegger/nvim-jdtls" },
  ["nvim_lsp_installer"] = { "williamboman/nvim-lsp-installer" },
  ["nvim_lspconfig"] = { "neovim/nvim-lspconfig", after = { "nvim-lsp-installer" } }, -- has to be loaded after nvim-lsp-installer
  ["lspsaga_nvim"] = { "glepnir/lspsaga.nvim" },
  ["neo_tree_nvim"] = {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = { "MunifTanjim/nui.nvim", "kyazdani42/nvim-web-devicons", "MunifTanjim/nui.nvim" },
  },
  ["nvim_ts_autotag"] = { "windwp/nvim-ts-autotag", event = "BufRead" },
  ["nvim_ts_context_commentstring"] = { "JoosepAlviste/nvim-ts-context-commentstring" },
  ["nvim_web_devicons"] = { "kyazdani42/nvim-web-devicons" },
  ["which_key_nvim"] = { "folke/which-key.nvim" },
  ["zen_mode_nvim"] = { "folke/zen-mode.nvim", event = "BufRead" },
  ["formatter_nvim"] = { "mhartington/formatter.nvim" },
}

local treesitter = {
  ["nvim_treesitter"] = { "nvim-treesitter/nvim-treesitter" },
  ["nvim_treesitter_textobjects"] = { "nvim-treesitter/nvim-treesitter-textobjects" },
}

local telescope = {
  ["telescope_fzf_native_nvim"] = { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
  ["telescope_nvim"] = { "nvim-telescope/telescope.nvim" },
  ["telescope_ui_select_nvim"] = { "nvim-telescope/telescope-ui-select.nvim" },
}

local nvim_cmp = {
  ["cmp_buffer"] = { "hrsh7th/cmp-buffer" },
  ["cmp_luasnip"] = { "saadparwaiz1/cmp_luasnip" },
  ["cmp_nvim_lsp"] = { "hrsh7th/cmp-nvim-lsp" },
  ["cmp_nvim_lsp_signature_help"] = { "hrsh7th/cmp-nvim-lsp-signature-help", event = "BufRead" },
  ["cmp_nvim_lua"] = { "hrsh7th/cmp-nvim-lua" },
  ["cmp_path"] = { "hrsh7th/cmp-path" },
  ["nvim_cmp"] = { "hrsh7th/nvim-cmp" },
}

local themes = {
  ["catppuccin_nvim"] = { "catppuccin/nvim" },
  ["gruvbox"] = { "gruvbox-community/gruvbox" },
  ["onenord_nvim"] = { "rmehri01/onenord.nvim" },
  ["sonokai"] = { "sainnhe/sonokai" },
}

local plugins = vim.tbl_deep_extend("error", base, common, telescope, treesitter, nvim_cmp, themes)

local present, packer = pcall(require, "packer")

if not present then
  print("ERROR! Cannot load packer!")
  return
end

local options = {
  auto_clean = true,
  compile_on_sync = true,
  git = { clone_timeout = 6000 },
  display = {
    working_sym = " ﲊ",
    error_sym = "✗ ",
    done_sym = " ",
    removed_sym = " ",
    moved_sym = "",
    open_fn = function()
      return require("packer.util").float({ border = "single" })
    end,
  },
}
packer.init(options)

-- TODO: autocreate config file, also: print warning w/ list of unused config files

for key, _ in pairs(plugins) do
  local config_path = vim.env.HOME .. "/.config/nvim/lua/nvim2/plugins/configs/" .. key .. ".lua"
  require("nvim2.utils").ensure_file_exists(config_path, "-- config for " .. key)
end

local function create_config_function(config)
  local fnstr = string.format('function() require("%s") end', config)
  -- MAGIC!
  return load("return " .. fnstr)
end

for key, plugin in pairs(plugins) do
  local plugin_conf_location = "nvim2.plugins.configs." .. key
  plugin.config = create_config_function(plugin_conf_location)()
end

packer.startup(function(use, use_rocks)
  -- use_rocks({ 'penlight' })
  for _, plugin in pairs(plugins) do
    use(plugin)
  end
end)
