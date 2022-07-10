require("lspconfig")

local M = {}

-- Borders for LspInfo winodw
local win = require "lspconfig.ui.windows"
local _default_opts = win.default_opts

win.default_opts = function(options)
   local opts = _default_opts(options)
   opts.border = "single"
   return opts
end

M.on_attach = function(client, _)
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

require("nvim2.languages").init()

return M
