local M = {}

M.lsp = {}

M.lsp.lspconfig_lspserver = "lemminx"

M.lsp.on_attach = function()
  -- require("cmp").setup.buffer({
  --   sources = {
  --     { name = 'nvim_lsp' },
  --     { name = 'luasnip' },
  --     { name = 'nvim_lsp_signature_help' },
  --   },
  -- })
end

M.lsp.settings = {
  -- Lua = {
  --   runtime = {
  --     -- tell the language server which version of lua you're using (most likely luajit in the case of neovim)
  --     version = 'luajit',
  --   },
  --   diagnostics = {
  --     -- get the language server to recognize the `vim` global
  --     globals = {'vim'},
  --   },
  --   workspace = {
  --     library = vim.api.nvim_get_runtime_file("", true),
  --   },
  --   -- do not send telemetry data containing a randomized but unique identifier
  --   telemetry = {
  --     enable = false,
  --   },
  -- },
}

return M

