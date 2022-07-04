local M = {}

local M = require("nvim2.classes.language"):new("xml", "xml")

M:set_lspserver("lemminx")

local cmp_sources = {
  { name = 'luasnip' },
  { name = 'nvim_lsp' },
  -- { name = 'nvim_lsp_signature_help' },
  { name = "buffer" },
  { name = "path" },
}
M:set_cmp_sources(cmp_sources)

return M
