local lsp = require('nvim2.languages.lsp')
local M = {}

-- M.efm = {
--     {
--         formatCommand = 'shfmt',
--         formatStdin = true,
--     },
--     {
--         lintCommand = 'shellcheck -f gcc -x',
--         lintSource = 'shellcheck',
--         lintFormats = {
--             '%f:%l:%c: %trror: %m',
--             '%f:%l:%c: %tarning: %m',
--             '%f:%l:%c: %tote: %m',
--         },
--     },
-- }
--
-- M.all_format = {
--     efm = 'Shfmt   shellcheck',
-- }
--
-- M.default_format = 'efm'

M.lsp_server = 'ansiblels'

M.lsp = {
  capabilities = lsp.capabilities,
  on_attach = lsp.on_attach,
  settings = {
    ansible = {
      ansible = {
        path = "ansible"
      },
      ansibleLint = {
        enabled = true,
        path = "ansible-lint"
      },
      executionEnvironment = {
        enabled = false
      },
      python = {
        interpreterPath = "python"
      }
    }
  }
}

return M


