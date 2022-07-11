local Class = require("nvim2.utils").Class
local lspconfig = require("lspconfig")
local cmp = require("cmp")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

local default_cmp_sources = {
  { name = "luasnip" },
  { name = "nvim_lsp" },
  { name = "nvim_lsp_signature_help" },
  { name = "buffer" },
  { name = "path" },
}

-- I am probably doing this wrong but idc it works
local init = function(name, filetype)
  local o = {}
  ----------------------------- fields -----------------------------------------
  o.name = name
  o.filetype = filetype
  o.use_lspconfig = true
  o.lspserver = nil
  o.lsp = {
    capabilities = capabilities,
    on_attach = function() end,
    settings = {},
  }
  o.autoformat = true
  o.cmp_sources = default_cmp_sources
  o.filetype_autocmd = function() end
  ------------------------------------------------------------------------------
  ----------------------------- methods ----------------------------------------

  function o:set_lspserver(value)
    self.lspserver = value
    return self
  end

  function o:set_lsp(value)
    self.lsp = value
  end

  function o:set_filetype_autocmd(fn)
    self.filetype_autocmd = fn
  end

  function o:set_cmp_sources(cmp_sources)
    self.cmp_sources = cmp_sources
  end

  function o:setup()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = self.filetype,
      callback = function()
        cmp.setup.buffer({ sources = self.cmp_sources })
      end,
      group = vim.api.nvim_create_augroup("set_cmp_sources_" .. self.filetype, {}),
    })
    if self.use_lspconfig then
      self.lsp.capabilities = self.lsp.capabilities or capabilities
      lspconfig[self.lspserver].setup(self.lsp)
    end
    if self.filetype_autocmd then
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.filetype,
        callback = self.filetype_autocmd,
        group = vim.api.nvim_create_augroup("filetype_autocmd_" .. self.filetype, {}),
      })
    end
    G.languages[self.filetype] = self
  end
  ------------------------------------------------------------------------------

  return o
end

local Language = {}
function Language:new(name, filetype)
  local o = init(name, filetype)
  return setmetatable(o, Class(Language))
end
return Language
