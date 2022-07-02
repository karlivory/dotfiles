local lspconfig = require('lspconfig')

local settings = require('nvim2.settings')
local setting_lanuages = require('nvim2.languages.languages')
local setting_lsps = require('nvim2.lsp.lsp')
local setting_lspconfig = settings.lspconfigs

local filetypes = setting_lspconfig.filetypes
local features = setting_lspconfig.features

for _, filetype in pairs(filetypes) do
    local language = setting_lanuages[filetype]
    lspconfig[language.lsp_server].setup(language.lsp)
end

-- for _, feature in pairs(features) do
--     local lsp = setting_lsps[feature]
--     lspconfig[lsp.lsp_server].setup(lsp.lsp)
-- end
