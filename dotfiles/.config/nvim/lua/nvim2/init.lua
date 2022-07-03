local present, impatient = pcall(require, "impatient")
if present then
  impatient.enable_profile()
end

function _G.ReloadConfig()
  for name,_ in pairs(package.loaded) do
    if name:match('^nvim2') then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
  print("Config reloaded!")
end

_G.CloseAllFloatingWindows = function()
  local closed_windows = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then -- is_floating_window?
      vim.api.nvim_win_close(win, false) -- do not forcefully
      table.insert(closed_windows, win)
    end
  end
  print(string.format('Closed %d windows: %s', #closed_windows, vim.inspect(closed_windows)))
end

require("nvim2.utils.core").disable_builtin_plugins()

require("nvim2.plugins.packer")

require('nvim2.options')
require('nvim2.lsp.icon')
-- these are slower than load_mappings(); "<cmd> lua require(...)" is better for mappings
require('nvim2.mappings')
require('nvim2.autocommands')
require('nvim2.ui.statusline')

-- vim.defer_fn(function()
-- require('nvim2.ui.base46').reload_theme()
-- end, 0)

local autocmd = vim.api.nvim_create_autocmd
-- Disable statusline in dashboard
autocmd("FileType", {
   pattern = "alpha",
   callback = function()
      vim.opt.laststatus = 0
   end,
})

autocmd("BufUnload", {
   buffer = 0,
   callback = function()
      vim.opt.laststatus = 3
   end,
})


require("nvim2.temp.utils").load_mappings()
require("nvim2.utils.").change_colorscheme("gruvbox")
