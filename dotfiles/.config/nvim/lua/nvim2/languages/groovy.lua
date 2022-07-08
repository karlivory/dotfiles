local M = require("nvim2.classes.language"):new("groovy", "groovy")

M:set_lspserver("groovyls")

local cmp_sources = {
  -- { name = 'luasnip' },
  -- { name = 'nvim_lsp' },
  -- { name = 'nvim_lsp_signature_help' },
  -- { name = "buffer" },
  -- { name = "path" },
}
M:set_cmp_sources(cmp_sources)

return M


