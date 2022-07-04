local M = require("nvim2.classes.language"):new("java", "java")
M:set_lspserver("jdtls")
M.use_lspconfig = false

M.filetype_autocmd = function()
  require("nvim2.plugins.configs.nvim_jdtls").setup()
end

return M

