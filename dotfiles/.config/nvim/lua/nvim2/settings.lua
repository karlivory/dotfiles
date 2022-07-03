local M = {}

M.ui = {
   -- hl = highlights
   hl_add = {},
   hl_override = {},
   changed_themes = {},
   theme_toggle = { "onedark", "one_light" },
   theme = "gruvbox", -- default theme
   transparency = false,

   statusline = {
      separator_style = "default", -- default/round/block/arrow
      config = "%!v:lua.require('ui.statusline').run()",
      override = {},
   },

   -- lazyload it when there are 1+ buffers
   tabufline = {
      enabled = true,
      lazyload = true,
      override = {},
   },
}

M.efm = {
  filetypes = {
    -- 'sh',
    -- 'css',
    -- 'cpp',
    -- 'dart',
    -- 'dockerfile',
    -- 'elixir',
    -- 'go',
    -- 'haskell',
    -- 'html',
    -- 'java',
    -- 'javascript',
    -- 'javascriptreact',
    -- 'json',
    -- 'lua',
    -- 'markdown',
    -- 'php',
    -- 'python',
    -- 'rust',
    -- 'solidity',
    -- 'svelte',
    -- 'tex',
    -- 'typescript',
    -- 'typescriptreact',
    -- 'xml',
    -- 'yaml',
  },
}

M.lspconfigs = {
  filetypes = {
    'sh',
    "yaml.ansible",
    -- 'cmake',
    -- 'css',
    -- 'cpp',
    -- 'dart',
    -- 'dockerfile',
    -- 'elixir',
    -- 'go',
    -- 'haskell',
    -- 'html',
    -- 'javascript',
    -- 'json',
    'lua',
    -- 'php',
    -- 'python',
    -- 'rust',
    -- 'solidity',
    -- 'svelte',
    -- 'tex',
    -- 'xml',
    -- -- 'yaml',
    -- 'zig',
  },

  features = {
    -- 'efm',
    -- 'emmet',
    -- 'tailwindcss',
  },
}

M.autoformat = {
  filetypes = {
    -- 'sh',
    -- 'cmake',
    -- 'css',
    -- 'cpp',
    -- 'dart',
    -- 'dockerfile',
    -- 'elixir',
    -- 'go',
    -- 'haskell',
    -- 'html',
    -- 'java',
    -- 'javascript',
    -- 'javascriptreact',
    -- 'json',
    -- 'lua',
    -- 'markdown',
    -- 'php',
    -- 'python',
    -- 'rust',
    -- 'solidity',
    -- 'svelte',
    -- 'tex',
    -- 'typescript',
    -- 'typescriptreact',
    -- 'xml',
    -- 'yaml',
  },
}

M.codeaction = {
  filetypes = {
    -- 'css',
    -- 'cpp',
    -- 'dart',
    -- 'dockerfile',
    -- 'go',
    -- 'html',
    -- -- 'java',
    -- 'javascript',
    -- 'javascriptreact',
    -- 'json',
    -- -- 'lua',
    -- 'markdown',
    -- 'php',
    -- 'python',
    -- 'rust',
    -- 'svelte',
    -- 'tex',
    -- 'typescript',
    -- 'typescriptreact',
    -- 'xml',
    -- 'yaml',
  },
}

M.signs = {
  DiagnosticSignError = ' ',
  DiagnosticSignWarning = ' ',
  DiagnosticSignHint = ' ',
  DiagnosticSignInfo = ' ',
  CodeActionSign = ' ',
}

M.kinds = {
  Class = ' (class)',
  Color = ' (color)',
  Constant = ' (constant)',
  Constructor = ' (constructor)',
  Enum = ' (enum)',
  EnumMember = ' (enum member)',
  Event = ' (event)',
  Field = ' (field)',
  File = ' (file)',
  Folder = ' (folder)',
  Function = ' (function)',
  Interface = ' (interface)',
  Keyword = ' (keyword)',
  Method = ' (method)',
  Module = '{} (module)',
  Operator = ' (operator)',
  Property = ' (property)',
  Reference = ' (reference)',
  Snippet = ' (snippet)',
  Struct = ' (enum)',
  Text = ' (text)',
  TypeParameter = ' (type parameter)',
  Unit = ' (unit)',
  Value = ' (value)',
  Variable = ' (variable)',
}

M.statusline = {
  git_branch_enabled = true,
  diagnostic_enabled = true,
  git_diff_enabled = true,
  test_enabled = true,
  line_column_enabled = true,
  tab_enabled = true,
  line_break_enabled = true,
  file_format_enabled = true,
  efm_enabled = true,
  emoji_enabled = true,
  emoji_icon = '',
}

return M
