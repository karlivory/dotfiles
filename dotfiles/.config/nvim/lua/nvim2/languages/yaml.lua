local M = {}

local M = require("nvim2.classes.language"):new("yaml", "yaml")

M:set_lspserver("yamlls")

local cmp_sources = {
  -- { name = 'luasnip' },
  { name = 'nvim_lsp' },
  -- { name = 'nvim_lsp_signature_help' },
  { name = "buffer", max_item_count = 7 },
  { name = "path" },
}
M:set_cmp_sources(cmp_sources)

local lsp = {
  settings = {
    yaml = {
      schemas = {
        -- ['https://raw.githubusercontent.com/docker/cli/master/cli/compose/schema/data/config_schema_v3.9.json'] = '/docker-compose.yml',
        -- ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
      },
    },
  }
}

return M
