local M = {}

-- local lspconfig = require('lspconfig')
-- local formatter = require("formatter")

local languages = {}

languages["yaml.ansible"] = require("nvim2.languages.ansible")
languages["sh"] = require("nvim2.languages.bash")
languages["lua"] = require("nvim2.languages.lua")
languages["cpp"] = require("nvim2.languages.cpp")
languages["java"] = require("nvim2.languages.java")
languages["xml"] = require("nvim2.languages.xml")
languages["yaml"] = require("nvim2.languages.yaml")
languages["gradle"] = require("nvim2.languages.gradle")
-- languages ["groovy"] = require('nvim2.languages.groovy')
languages["kotlin"] = require("nvim2.languages.kotlin")
languages["python"] = require("nvim2.languages.python")

M.init = function()
  for _, language in pairs(languages) do
    language:setup()
  end
end

return M
