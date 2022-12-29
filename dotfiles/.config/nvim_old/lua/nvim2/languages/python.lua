local M = require("nvim2.classes.language"):new("lua", "lua")

M:set_lspserver("pyright")

local cmp_sources = {
  { name = "nvim_lsp" },
  { name = "nvim_lsp_signature_help" },
  { name = "buffer" },
  { name = "path" },
}
M:set_cmp_sources(cmp_sources)

return M
