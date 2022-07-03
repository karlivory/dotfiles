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

M.filetype_autocmd = function()
end

M.lsp = {}

M.lsp.lspconfig_lspserver = "bashls"

M.lsp.on_attach = function()
  require("cmp").setup.buffer({
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'nvim_lsp_signature_help' },
    },
  })
end

return M

