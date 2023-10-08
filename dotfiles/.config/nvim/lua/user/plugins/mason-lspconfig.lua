return {
  "williamboman/mason-lspconfig.nvim",
  opts = {
    automatic_installation = true,
    ensure_installed = {
      "ansiblels",
      "bashls",
      "clangd",
      "cssls",
      "html",
      "jdtls",
      "jsonls",
      "lemminx",
      "gopls",
      "lua_ls",
      "svelte",
      "tailwindcss",
      "tsserver",
      "yamlls",
      -- "pyright", -- managed by astrocommunity.pack.python
    }
  }
}
