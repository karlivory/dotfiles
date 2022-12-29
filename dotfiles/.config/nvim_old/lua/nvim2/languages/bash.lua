local M = require("nvim2.classes.language"):new("bash", "sh")

M:set_lspserver("bashls")

return M
