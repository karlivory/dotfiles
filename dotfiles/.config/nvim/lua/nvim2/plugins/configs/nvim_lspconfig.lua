lspconfig = require("lspconfig")

local M = {}

-- Borders for LspInfo winodw
local win = require "lspconfig.ui.windows"
local _default_opts = win.default_opts

win.default_opts = function(options)
   local opts = _default_opts(options)
   opts.border = "single"
   return opts
end

M.on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
   documentationFormat = { "markdown", "plaintext" },
   snippetSupport = true,
   preselectSupport = true,
   insertReplaceSupport = true,
   labelDetailsSupport = true,
   deprecatedSupport = true,
   commitCharactersSupport = true,
   tagSupport = { valueSet = { 1 } },
   resolveSupport = {
      properties = {
         "documentation",
         "detail",
         "additionalTextEdits",
      },
   },
}
-- lspconfig.eslint.setup{}
-- lspconfig.tsserver.setup{}
--
-- lspconfig.pyright.setup{}
-- -- lspconfig.jedi_language_server.setup{}
--
-- lspconfig.bashls.setup{}
--
-- lspconfig.ansiblels.setup{}
-- require('nvim2.lsp.lspconfig')

-- local luadev = require("lua-dev").setup({
--   -- add any options here, or leave empty to use the default settings
--   -- lspconfig = {
--   --   cmd = {"lua-language-server"}
--   -- },
-- })
--
-- local lspconfig = require('lspconfig')
-- lspconfig.sumneko_lua.setup(luadev)
-- print(vim.inspect(luadev))

require("nvim2.languages").init()

-- lspconfig.sumneko_lua.setup {
--    on_attach = M.on_attach,
--    capabilities = capabilities,
--
--    settings = {
--       Lua = {
--          diagnostics = {
--             globals = { "vim" },
--          },
--          workspace = {
--             library = {
--                 vim.api.nvim_get_runtime_file("", true),
--                [vim.fn.expand "$VIMRUNTIME/lua"] = true,
--                [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
--             },
--             maxPreload = 100000,
--             preloadFileSize = 10000,
--          },
--       },
--    },
-- }

return M


