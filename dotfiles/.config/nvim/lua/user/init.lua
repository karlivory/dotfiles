local config = {
  lsp = {
    skip_setup = { "rust_analyzer", "jdtls" }, -- skip lsp setup because rust-tools will do it itself
  },
  -- -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  -- diagnostics = {
  --   virtual_text = true,
  --   underline = true,
  -- },
  --
  -- -- LuaSnip Options
  -- luasnip = {
  --   -- Add paths for including more VS Code style snippets in luasnip
  --   vscode_snippet_paths = {},
  --   -- Extend filetypes
  --   filetype_extend = {
  --     -- javascript = { "javascriptreact" },
  --   },
  -- },
  polish = function()
    vim.api.nvim_create_autocmd("Filetype", {
      pattern = "java", -- autocmd to start jdtls
      callback = function()
        local config = astronvim.lsp.server_settings "jdtls"
        if config.root_dir and config.root_dir ~= "" then require("jdtls").start_or_attach(config) end
      end,
    })
  end,

}

return config
