return function()
  for name,_ in pairs(package.loaded) do
    if name:match('^nvim2') then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
  vim.cmd[[LspRestart]]
  print("Config reloaded!")
end
