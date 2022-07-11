local M = require("nvim2.classes.language"):new("java", "java")
M:set_lspserver("jdtls")
M.use_lspconfig = false

M.filetype_autocmd = function()
  vim.bo.shiftwidth = 2
  vim.bo.tabstop = 2
  require("nvim2.plugins.configs.nvim_jdtls").setup()
end

return M
