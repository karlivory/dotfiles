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
      -- "pyright", -- managed by pack
      "lua_ls",
      "svelte",
      "tailwindcss",
      "tsserver",
      "yamlls",
    }
  }
}
