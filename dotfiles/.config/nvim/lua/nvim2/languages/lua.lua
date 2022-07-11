local M = require("nvim2.classes.language"):new("lua", "lua")

M:set_lspserver("sumneko_lua")

local lua_lsp = {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
      },
      runtime = {
        -- tell the language server which version of lua you're using (most likely luajit in the case of neovim)
        version = "luaJIT",
      },
      diagnostics = {
        -- get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        maxPreload = 1000,
        preloadFileSize = 150,
      },
      -- do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}
M:set_lsp(lua_lsp)
M:set_filetype_autocmd(function()
  vim.bo.tabstop = 2
  vim.bo.shiftwidth = 2
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
