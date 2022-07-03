local M = {}

M.filetype_autocmd = function()
    require("nvim2.plugins.configs.nvim_jdtls").setup()
end

vim.api.nvim_create_user_command(
'Upper',
function(opts)
  print(string.upper(opts.args))
end,
{ nargs = 1 })

M.lsp = {}

M.lsp.on_attach = function(client, bufnr)
  require("jdtls.dap")
  require("jdtls").setup_dap({ hotcodereplace = "auto" })
  require("jdtls.setup").add_commands()
  require("jdtls.dap").setup_dap_main_class_configs()
  require("jdtls").setup_dap()
  require("lsp-status").register_progress()
end

return M

