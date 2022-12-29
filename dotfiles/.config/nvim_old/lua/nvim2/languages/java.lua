local M = require("nvim2.classes.language"):new("java", "java")
M:set_lspserver("jdtls")
M.use_lspconfig = false

M:set_filetype_autocmd(function()
  vim.bo.tabstop = 2
  vim.bo.shiftwidth = 2
  vim.bo.softtabstop = 2
  require("nvim2.plugins.configs.nvim_jdtls").setup()
end)

return M
