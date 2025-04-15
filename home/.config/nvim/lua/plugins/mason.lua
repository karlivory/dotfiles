---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install language servers
        "ansible-language-server",
        "bash-language-server",
        "css-lsp",
        "gopls",
        "html-lsp",
        "json-lsp",
        "lemminx",
        "lua-language-server",
        "tailwindcss-language-server",
        -- "vue-language-server",
        -- "yaml-language-server",

        -- install formatters
        "stylua",

        -- install debuggers
        -- -

        -- install any other package
        "tree-sitter-cli",
      },
    },
  },
}
