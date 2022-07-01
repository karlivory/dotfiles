-- local plugin_settings_fd = require("utils").get_plugin_settings_folder_name()
local ok, jd = pcall(require, "nvim.plugins.configs.nvim_jdtls")
jd.setup()
