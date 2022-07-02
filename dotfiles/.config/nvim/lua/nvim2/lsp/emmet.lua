local lsp = require('nvim2.languages.lsp')

return {
    lsp_server = 'emmet_ls',
    lsp = {
        capabilities = lsp.capabilities,
        on_attach = lsp.on_attach,
        filetypes = { 'html', 'css', 'svelte', 'javascriptreact', 'typescriptreact' },
    },
}
