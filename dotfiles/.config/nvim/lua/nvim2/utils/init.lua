local M = {}
local fn = vim.fn

M.change_colorscheme = require("nvim2.utils.change_colorscheme")
M.reload_config = require("nvim2.utils.reload_config")

M.extend = function(t, ...)
  for k, v in pairs({...}) do
    t[k] = v
  end
end

M.kmap = function (mode, lhs, rhs, mapping_name, mapping_opts)
  local opts = mapping_opts or {}
  local name = mapping_name or rhs
  local whichkey_exists, wk = pcall(require, "which-key")

  if whichkey_exists then
    opts.mode = mode
    wk.register({ [lhs] = { rhs, name } }, opts)
  else
    opts.mode = nil
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

-- M.file and M.ensure_file_exists are copied from 
-- https://github.com/NvChad/extensions/tree/785eaa25a9bbdf47a6808dc5b6da1747abe10b2b

-- 1st arg - r or w
-- 2nd arg - file path
-- 3rd arg - content if 1st arg is w
-- return file data on read, nothing on write
M.file = function(mode, filepath, content)
   local data
   local base_dir = fn.fnamemodify(filepath, ":h")
   -- check if file exists in filepath, return false if not
   if mode == "r" and fn.filereadable(filepath) == 0 then
      return false
   end
   -- check if directory exists, create it and all parents if not
   if mode == "w" and fn.isdirectory(base_dir) == 0 then
      fn.mkdir(base_dir, "p")
   end
   local fd = assert(vim.loop.fs_open(filepath, mode, 438))
   local stat = assert(vim.loop.fs_fstat(fd))
   if stat.type ~= "file" then
      data = false
   else
      if mode == "r" then
         data = assert(vim.loop.fs_read(fd, stat.size, 0))
      else
         assert(vim.loop.fs_write(fd, content, 0))
         data = true
      end
   end
   assert(vim.loop.fs_close(fd))
   return data
end

-- ensures the given file_path is a valid path
-- if the file at file_path does not exist, it will be created with the given default_content
M.ensure_file_exists = function(file_path, default_content)
   -- store in data variable
   local data = M.file("r", file_path)

   -- check if data is false or nil and create a default file if it is
   if not data then
      M.file("w", file_path, default_content)
      data = M.file("r", file_path)
   end

   -- if the file was still not created, then something went wrong
   if not data then
      print(
         "Error: Could not create: "
         .. file_path
         .. ". Please create it manually to set a default "
         .. "theme. Look at the documentation for more info."
      )
      return false
   end

   return true
end

return M
