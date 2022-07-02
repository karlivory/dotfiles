local plugins = {
  ["packer_nvim"] = { "wbthomason/packer.nvim" },
  ["luasnip"] = { "L3MON4D3/LuaSnip" },
  ["bufferline_nvim"] = { "akinsho/bufferline.nvim" },
  ["cmp_buffer"] = { "hrsh7th/cmp-buffer" },
  ["cmp_luasnip"] = { "saadparwaiz1/cmp_luasnip" },
  ["cmp_nvim_lsp"] = { "hrsh7th/cmp-nvim-lsp" },
  ["cmp_nvim_lsp_signature_help"] = { "hrsh7th/cmp-nvim-lsp-signature-help", event = "BufRead" },
  ["cmp_nvim_lua"] = { "hrsh7th/cmp-nvim-lua" },
  ["cmp_path"] = { "hrsh7th/cmp-path" },
  ["nvim_comment"] = {'terrortylor/nvim-comment', event = "BufRead" },
  ["fidget_nvim"] = { "j-hui/fidget.nvim", event = "BufRead" },
  ["friendly_snippets"] = { "rafamadriz/friendly-snippets" },
  ["gitsigns_nvim"] = { "lewis6991/gitsigns.nvim", event = "BufRead" },
  ["gruvbox_nvim"] = { "ellisonleao/gruvbox.nvim" },
  ["impatient_nvim"] = { "lewis6991/impatient.nvim" },
  ["indent_blankline_nvim"] = { "lukas-reineke/indent-blankline.nvim", event = "BufRead" },
  ["lsp_signature_nvim"] = { "ray-x/lsp_signature.nvim", event = "BufRead" },
  ["nvim_autopairs"] = { "windwp/nvim-autopairs", event = "BufRead" },
  ["nvim_cmp"] = { "hrsh7th/nvim-cmp" },
  ["nvim_colorizer_lua"] = { "norcalli/nvim-colorizer.lua", event = "BufRead" },
  ["nvim_dap"] = { "mfussenegger/nvim-dap", ft = "java" },
  ["nvim_dap_ui"] = { "rcarriga/nvim-dap-ui", ft = "java" },
  ["nvim_dap_virtual_text"] = { "theHamsta/nvim-dap-virtual-text", ft = "java" },
  ["nvim_jdtls"] = { "mfussenegger/nvim-jdtls", ft = "java" },
  ["nvim_lsp_installer"] = { "williamboman/nvim-lsp-installer" },
  ["nvim_lspconfig"] = { "neovim/nvim-lspconfig" },
  ["nvim_tree_lua"] = { "kyazdani42/nvim-tree.lua", cmd = { "NvimTreeToggle", "NvimTreeFocus" } },
  ["nvim_treesitter"] = { "nvim-treesitter/nvim-treesitter" },
  ["nvim_ts_context_commentstring"] = { "JoosepAlviste/nvim-ts-context-commentstring" },
  ["nvim_web_devicons"]= { "kyazdani42/nvim-web-devicons" },
  ["plenary_nvim"] = { "nvim-lua/plenary.nvim" },
  ["telescope_fzf_native_nvim"] = {"nvim-telescope/telescope-fzf-native.nvim", run = 'make' },
  ["telescope_nvim"] = { "nvim-telescope/telescope.nvim" },
  ["toggleterm_nvim"] = {"akinsho/toggleterm.nvim"},
  ["which_key_nvim"] = { "folke/which-key.nvim" },
  ["nvim_ts_autotag"] = { "windwp/nvim-ts-autotag", event = "BufRead" },
  ["zen_mode_nvim"] = { "folke/zen-mode.nvim", event = "BufRead" },
}

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
      return require("packer.util").float { border = "single" }
    end,
  },
}
packer.init(options)

local function create_config_function(config)
  local fnstr = string.format('function() require("%s") end', config)
  -- MAGIC!
  return loadstring("return " .. fnstr)
end

for key, plugin in pairs(plugins) do
  local plugin_conf_location = "nvim2.plugins.configs." .. key
  plugin.config = create_config_function(plugin_conf_location)()
end

packer.startup(function(use)
  for key, plugin in pairs(plugins) do
    use(plugin)
  end
end)

