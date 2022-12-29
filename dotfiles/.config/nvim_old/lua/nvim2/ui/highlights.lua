local M = {}

local colors = require("nvim2.ui.colors")

local cmd = vim.cmd

local highlights = {
  DapBreakpoint = {
    fg = colors.default.tomato,
  },
  DapStopped = {
    fg = colors.default.orange,
  },
  St_gitIcons = {
    fg = colors.StatusLineColors.light_grey,
    bg = colors.StatusLineColors.statusline_bg,
    bold = true,
  },

  St_lspError = {
    fg = colors.StatusLineColors.red,
    bg = colors.StatusLineColors.statusline_bg,
  },

  St_lspWarning = {
    fg = colors.StatusLineColors.yellow,
    bg = colors.StatusLineColors.statusline_bg,
  },

  St_LspHints = {
    fg = colors.StatusLineColors.purple,
    bg = colors.StatusLineColors.statusline_bg,
  },

  St_LspInfo = {
    fg = colors.StatusLineColors.green,
    bg = colors.StatusLineColors.statusline_bg,
  },

  St_LspStatus = {
    fg = colors.StatusLineColors.nord_blue,
    bg = colors.StatusLineColors.statusline_bg,
  },

  St_LspProgress = {
    fg = colors.StatusLineColors.green,
    bg = colors.StatusLineColors.statusline_bg,
  },

  St_LspStatus_Icon = {
    fg = colors.StatusLineColors.black,
    bg = colors.StatusLineColors.nord_blue,
  },

  St_NormalMode = {
    bg = colors.StatusLineColors.red,
    fg = colors.StatusLineColors.black,
    bold = true,
  },

  St_InsertMode = {
    bg = colors.StatusLineColors.purple,
    fg = colors.StatusLineColors.black,

    bold = true,
  },

  St_TerminalMode = {
    bg = colors.StatusLineColors.green,
    fg = colors.StatusLineColors.black,
    bold = true,
  },

  St_NTerminalMode = {
    bg = colors.StatusLineColors.yellow,
    fg = colors.StatusLineColors.black,
    bold = true,
  },

  St_VisualMode = {
    bg = colors.StatusLineColors.cyan,
    fg = colors.StatusLineColors.black,
    bold = true,
  },

  St_ReplaceMode = {
    bg = colors.StatusLineColors.orange,
    fg = colors.StatusLineColors.black,

    bold = true,
  },

  St_ConfirmMode = {
    bg = colors.StatusLineColors.teal,
    fg = colors.StatusLineColors.black,

    bold = true,
  },

  St_CommandMode = {
    bg = colors.StatusLineColors.green,
    fg = colors.StatusLineColors.black,

    bold = true,
  },

  St_SelectMode = {
    bg = colors.StatusLineColors.red,
    fg = colors.StatusLineColors.black,

    bold = true,
  },

  St_NormalModeSep = {
    fg = colors.StatusLineColors.red,
    bg = colors.StatusLineColors.grey,
  },

  St_InsertModeSep = {
    fg = colors.StatusLineColors.purple,
    bg = colors.StatusLineColors.grey,
  },

  St_TerminalModeSep = {
    fg = colors.StatusLineColors.green,
    bg = colors.StatusLineColors.grey,
  },

  St_NTerminalModeSep = {
    fg = colors.StatusLineColors.yellow,
    bg = colors.StatusLineColors.grey,
  },

  St_VisualModeSep = {
    fg = colors.StatusLineColors.cyan,
    bg = colors.StatusLineColors.grey,
  },

  St_ReplaceModeSep = {
    fg = colors.StatusLineColors.orange,
    bg = colors.StatusLineColors.grey,
  },

  St_ConfirmModeSep = {
    fg = colors.StatusLineColors.teal,
    bg = colors.StatusLineColors.grey,
  },

  St_CommandModeSep = {
    fg = colors.StatusLineColors.green,
    bg = colors.StatusLineColors.grey,
  },

  St_SelectModeSep = {
    fg = colors.StatusLineColors.red,
    bg = colors.StatusLineColors.grey,
  },

  St_EmptySpace = {
    fg = colors.StatusLineColors.grey,
    bg = colors.StatusLineColors.lightbg,
  },

  St_EmptySpace2 = {
    fg = colors.StatusLineColors.grey,
    bg = colors.StatusLineColors.statusline_bg,
  },

  St_file_info = {
    bg = colors.StatusLineColors.lightbg,
    fg = colors.StatusLineColors.white,
  },

  St_file_sep = {
    bg = colors.StatusLineColors.statusline_bg,
    fg = colors.StatusLineColors.lightbg,
  },

  St_cwd_icon = {
    fg = colors.StatusLineColors.one_bg,
    bg = colors.StatusLineColors.red,
  },

  St_cwd_text = {
    fg = colors.StatusLineColors.white,
    bg = colors.StatusLineColors.lightbg,
  },

  St_cwd_sep = {
    fg = colors.StatusLineColors.red,
    bg = colors.StatusLineColors.statusline_bg,
  },

  St_pos_sep = {
    fg = colors.StatusLineColors.green,
    bg = colors.StatusLineColors.lightbg,
  },

  St_pos_icon = {
    fg = colors.StatusLineColors.black,
    bg = colors.StatusLineColors.green,
  },

  St_pos_text = {
    fg = colors.StatusLineColors.green,
    bg = colors.StatusLineColors.lightbg,
  },
}

local function highlight(all_highlights)
  for group, ui in pairs(all_highlights) do
    local guifg = ui.guifg or ui.fg or "NONE"
    local guibg = ui.guibg or ui.bg or "NONE"
    local bold = ui.bold
    local gui = ""
    if bold then
      gui = "bold"
    end
    if gui == "" then
      gui = "NONE"
    end
    cmd(string.format("hi %s guifg=%s guibg=%s gui=%s", group, guifg, guibg, gui))
  end
end

M.load_highlights = function()
  highlight(highlights)
end

return M
