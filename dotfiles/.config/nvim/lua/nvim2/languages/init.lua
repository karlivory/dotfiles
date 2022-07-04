local M = {}

local lspconfig = require('lspconfig')

local languages = {
  ["yaml.ansible"] = require("nvim2.languages.ansible"),
  ["sh"] = require('nvim2.languages.bash'),
  ["lua"] = require('nvim2.languages.lua'),
  ["cpp"] = require('nvim2.languages.cpp'),
  ["java"] = require('nvim2.languages.java'),
  ["xml"] = require('nvim2.languages.xml'),
  ["yaml"] = require('nvim2.languages.yaml')
}

M.init = function()
  for _, language in pairs(languages) do
    language:setup()
  end
end

return M

