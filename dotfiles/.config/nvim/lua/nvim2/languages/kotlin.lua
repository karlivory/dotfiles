local M = require("nvim2.classes.language"):new("kotlin", "kotlin")

M:set_lspserver("kotlin_language_server")

local cmp_sources = {
  -- { name = 'luasnip' },
  { name = "nvim_lsp" },
  { name = "nvim_lsp_signature_help" },
  { name = "buffer" },
  { name = "path" },
}
M:set_cmp_sources(cmp_sources)

return M
