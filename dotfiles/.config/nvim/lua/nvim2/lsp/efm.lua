local lspconfig = require('lspconfig')

local lsp = require('nvim2.languages.lsp')
local settings = require('nvim2.settings')
local setting_lanuages = require('nvim2.languages.languages')
local filetypes = settings.efm.filetypes
local languages = {}

for _, filetype in pairs(filetypes) do
    languages[filetype] = setting_lanuages[filetype].efm
end

return {
    lsp_server = 'efm',
    lsp = {
        root_dir = lspconfig.util.root_pattern('.git'),
        filetypes = filetypes,

        init_options = { documentFormatting = true, codeAction = true },
        settings = {
            rootMarkers = { '.git/' },
            languages = languages,
        },

        on_attach = lsp.on_attach,
        capabilities = lsp.capabilities,
    },
}
