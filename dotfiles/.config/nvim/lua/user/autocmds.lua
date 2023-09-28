-- some kind of bug w/ markdown & GuessIndent not working properly (TODO: github issue?)
vim.api.nvim_create_autocmd(
  { "BufRead", },
  {
    pattern = "*.md",
    callback = function()
      local function setindent()
        require("guess-indent").set_from_buffer()
      end
      vim.loop.new_timer():start(200, 0, vim.schedule_wrap(setindent))
    end
  }
)
