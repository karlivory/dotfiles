local present, impatient = pcall(require, "impatient")
if present then
  impatient.enable_profile()
end

require("nvim2.utils.core").disable_builtin_plugins()

require("nvim2.globals")
require("nvim2.plugins.packer")
require('nvim2.options')
require('nvim2.ui.statusline')
require("nvim2.utils").change_colorscheme("gruvbox")
require('nvim2.mappings')
require('nvim2.autocommands')

require("nvim2.languages.ansible")
require('nvim2.languages.bash')
require('nvim2.languages.lua')
require('nvim2.languages.cpp')
require('nvim2.languages.java')
require('nvim2.languages.xml')
require('nvim2.languages.yaml')
require('nvim2.languages.gradle')
require('nvim2.languages.groovy')
require('nvim2.languages.kotlin')
require('nvim2.languages.python')
