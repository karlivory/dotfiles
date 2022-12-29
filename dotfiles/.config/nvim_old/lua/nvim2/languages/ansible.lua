local M = require("nvim2.classes.language"):new("ansible", "yaml.ansible")

M:set_lspserver("ansiblels")
local lsp = {
  settings = {
    ansible = {
      ansible = {
        path = "ansible",
      },
      ansibleLint = {
        enabled = false,
        path = "ansible-lint",
      },
      executionEnvironment = {
        enabled = false,
      },
      python = {
        interpreterPath = "python",
      },
      completion = {
        provideRedirectModules = true,
        provideModuleOptionAliases = true,
      },
    },
  },
}
M:set_lsp(lsp)
local cmp_sources = {
  { name = "nvim_lsp" },
  { name = "buffer" },
  { name = "path" },
}
M:set_cmp_sources(cmp_sources)

return M
