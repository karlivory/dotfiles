local M = require("nvim2.classes.language"):new("tailwindcss", "svelte")

M:set_lspserver("tailwindcss")

M:set_lsp({
  filetypes = {
    "ejs",
    "html",
    "css",
    "postcss",
    "sass",
    "scss",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "svelte",
  },
})
M:set_filetype_autocmd(function()
  vim.bo.tabstop = 2
  vim.bo.shiftwidth = 2
  vim.bo.softtabstop = 2
end)

local cmp_sources = {
  { name = "luasnip" },
  { name = "nvim_lsp" },
  { name = "nvim_lsp_signature_help" },
  { name = "nvim_lua" },
  { name = "buffer" },
  { name = "path" },
}
M:set_cmp_sources(cmp_sources)

return M
