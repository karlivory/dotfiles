local M = require("nvim2.classes.language"):new("typescript", "svelte")

M:set_lspserver("tsserver")

return M
