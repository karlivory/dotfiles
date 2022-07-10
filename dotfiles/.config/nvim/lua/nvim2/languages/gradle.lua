local M = require("nvim2.classes.language"):new("gradle", "groovy")

M:set_lspserver("gradle_ls")

local cmp_nvim_lsp = require("cmp_nvim_lsp")


local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

local lsp = {
  cmd = {
    "java",
    "-jar",
    vim.env.HOME .. "/.local/ls/gradle/gradle-language-server/build/install/gradle-language-server/lib/gradle-language-server.jar"
  },
  root_dir = function(fname)
    return require("lspconfig.util").root_pattern(unpack { "settings.gradle", "settings.gradle.kts" })(fname)
    or require("lspconfig.util").root_pattern(unpack { "build.gradle" })(fname)
  end,
  filetypes = { "groovy", "kotlin" },
  capabilities = capabilities,
  init_options = {
    settings = {
      gradleWrapperEnabled = true,
    }
  },
}
M:set_lsp(lsp)

local cmp_sources = {
  -- { name = 'luasnip' },
  { name = 'nvim_lsp' },
  { name = 'nvim_lsp_signature_help' },
  { name = "buffer" },
  { name = "path" },
}
M:set_cmp_sources(cmp_sources)

return M

