local function setindent(indent)
  vim.bo.expandtab = (indent > 0)
  indent = math.abs(indent)
  vim.bo.tabstop = indent
  vim.bo.softtabstop = indent
  vim.bo.shiftwidth = indent
  require("guess-indent").set_from_buffer()
end

local function indenter(indent)
  vim.loop.new_timer():start(200, 0, vim.schedule_wrap(function() setindent(indent) end))
end

-- some kind of bug w/ markdown & GuessIndent not working properly (TODO: github issue?)
vim.api.nvim_create_autocmd(
  { "BufEnter", },
  {
    pattern = "*.md",
    callback = function()
      indenter(2)
    end
  }
)
