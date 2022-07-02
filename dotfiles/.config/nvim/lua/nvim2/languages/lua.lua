local lsp = require("nvim2.languages.lsp")
local M = {}

local api = vim.api

local function on_attach(_, bufnr)
  local opts = { noremap = true, silent = true }

  local function buf_set_keymap(mode, mapping, command)
    api.nvim_buf_set_keymap(bufnr, mode, mapping, command, opts)
  end

  if vim.bo.filetype == 'zig' then
    client.resolved_capabilities.code_action = true
  end

  require("cmp").setup.buffer({
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'nvim_lsp_signature_help' },
    },
  })

  buf_set_keymap('n', '<Leader>d', '<Cmd>lua vim.lsp.buf.definition()<CR>')
  buf_set_keymap('n', '<Leader><Leader>', '<Cmd>lua vim.lsp.buf.hover()<CR>')
  buf_set_keymap('n', '<Leader>r', '<cmd>lua require("utils.core").rename_popup()<CR>')
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')

  buf_set_keymap('n', '<M-x>', [[<Cmd>lua require('sidebar').toggle('symbol')<CR>]])
  buf_set_keymap('n', '[x', '<cmd>AerialPrev<CR>')
  buf_set_keymap('n', ']x', '<cmd>AerialNext<CR>')
end

M.lsp_server = "sumneko_lua"

M.lsp = {
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

return M
