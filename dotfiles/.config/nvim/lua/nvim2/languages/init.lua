local M = {}

local lspconfig = require('lspconfig')

local languages_metatable = {
  {
    lsp = {
      lspconfig_server = "",
      on_attach = function() end,
      capabilities = {},
      settings = {}
    },
    filetype_autocmd = function() end
  },
}

local languages = {
  ["yaml.ansible"] = require("nvim2.languages.ansible"),
  ["sh"] = require('nvim2.languages.bash'),
  ["lua"] = require('nvim2.languages.lua'),
  ["java"] = require('nvim2.languages.java')
}
setmetatable(languages, languages_metatable)
for key, language in pairs(languages) do
  language.filetype = key
end

local get_default_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  return capabilities
end

local function setup_lspconfig(language)
  local lspserver = language.lsp.lspconfig_lspserver
  language.lsp.on_attach = language.lsp.on_attach or function() end
  language.lsp.capabilities = language.lsp.capabilities or get_default_capabilities()
  lspconfig[lspserver].setup(language.lsp)
end

local function setup_filetype_autocmd(language)
  local autocmd = language.filetype_autocmd
  vim.api.nvim_create_autocmd('FileType', {
    pattern = language.filetype,
    callback = autocmd,
    group = vim.api.nvim_create_augroup('filetype_' .. language.filetype, {})
  })
end

M.init = function()
  for _, language in pairs(languages) do
    if(language.lsp.lspconfig_lspserver) then
      setup_lspconfig(language)
    end
  end

  for _, language in pairs(languages) do
    if(language.filetype_autocmd) then
      setup_filetype_autocmd(language)
    end
  end
end

return M

