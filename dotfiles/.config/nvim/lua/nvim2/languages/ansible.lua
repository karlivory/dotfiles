local M = {}

M.filetype_autocmd = function()
end

M.lsp = {}

M.lsp.lspconfig_lspserver = "ansiblels"

M.lsp.on_attach = function()
  require("cmp").setup.buffer({
    sources = {
      { name = 'nvim_lsp' },
      -- { name = 'luasnip' },
      { name = 'nvim_lsp_signature_help' },
    },
  })
end

M.lsp.settings = {
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

return M

