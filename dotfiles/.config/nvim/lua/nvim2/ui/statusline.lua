local fn = vim.fn
local sep_style = require("nvim2.ui.icons").statusline_separators
local user_sep = "default"
local sep_l = sep_style[user_sep]["left"]
local sep_r = sep_style[user_sep]["right"]

local modes = {
  ["n"] = { "NORMAL", "St_NormalMode" },
  ["niI"] = { "NORMAL i", "St_NormalMode" },
  ["niR"] = { "NORMAL r", "St_NormalMode" },
  ["niV"] = { "NORMAL v", "St_NormalMode" },
  ["no"] = { "N-PENDING", "St_NormalMode" },
  ["i"] = { "INSERT", "St_InsertMode" },
  ["ic"] = { "INSERT", "St_InsertMode" },
  ["ix"] = { "INSERT completion", "St_InsertMode" },
  ["t"] = { "TERMINAL", "St_TerminalMode" },
  ["nt"] = { "NTERMINAL", "St_NTerminalMode" },
  ["v"] = { "VISUAL", "St_VisualMode" },
  ["V"] = { "V-LINE", "St_VisualMode" },
  [""] = { "V-BLOCK", "St_VisualMode" },
  ["R"] = { "REPLACE", "St_ReplaceMode" },
  ["Rv"] = { "V-REPLACE", "St_ReplaceMode" },
  ["s"] = { "SELECT", "St_SelectMode" },
  ["S"] = { "S-LINE", "St_SelectMode" },
  [""] = { "S-BLOCK", "St_SelectMode" },
  ["c"] = { "COMMAND", "St_CommandMode" },
  ["cv"] = { "COMMAND", "St_CommandMode" },
  ["ce"] = { "COMMAND", "St_CommandMode" },
  ["r"] = { "PROMPT", "St_ConfirmMode" },
  ["rm"] = { "MORE", "St_ConfirmMode" },
  ["r?"] = { "CONFIRM", "St_ConfirmMode" },
  ["!"] = { "SHELL", "St_TerminalMode" },
}

local M = {}

M.mode = function()
  local m = vim.api.nvim_get_mode().mode
  local current_mode = "%#" .. modes[m][2] .. "#" .. "  " .. modes[m][1]
  local mode_sep1 = "%#" .. modes[m][2] .. "Sep" .. "#" .. sep_r

  return current_mode .. mode_sep1 .. "%#ST_EmptySpace#" .. sep_r
end

M.fileInfo = function()
  local icon = "  "
  local filename = (fn.expand("%") == "" and "Empty ") or fn.expand("%:t")

  if filename ~= "Empty " then
    local devicons_present, devicons = pcall(require, "nvim-web-devicons")

    if devicons_present then
      local ft_icon = devicons.get_icon(filename)
      icon = (ft_icon ~= nil and " " .. ft_icon) or ""
    end

    filename = " " .. filename .. " "
  end

  return "%#St_file_info#" .. icon .. filename .. "%#St_file_sep#" .. sep_r
end

M.git = function()
  if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
    return ""
  end

  local git_status = vim.b.gitsigns_status_dict

  local added = (git_status.added and git_status.added ~= 0) and ("  " .. git_status.added) or ""
  local changed = (git_status.changed and git_status.changed ~= 0) and ("  " .. git_status.changed) or ""
  local removed = (git_status.removed and git_status.removed ~= 0) and ("  " .. git_status.removed) or ""
  local branch_name = "   " .. git_status.head .. " "

  return "%#St_gitIcons#" .. branch_name .. added .. changed .. removed
end

-- LSP STUFF
M.LSP_progress = function()
  local Lsp = vim.lsp.util.get_progress_messages()[1]

  if vim.o.columns < 120 or not Lsp then
    return ""
  end

  local msg = Lsp.message or ""
  local percentage = Lsp.percentage or 0
  local title = Lsp.title or ""
  local spinners = { "", "" }
  local ms = vim.loop.hrtime() / 1000000
  local frame = math.floor(ms / 120) % #spinners
  local content = string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)

  return ("%#St_LspProgress#" .. content) or ""
end

M.LSP_Diagnostics = function()
  local error_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warning_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local hint_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  local info_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

  local error_str = (error_count and error_count > 0) and ("%#St_lspError#" .. " " .. error_count .. " ") or ""
  local warning_str = (warning_count and warning_count > 0) and ("%#St_lspWarning#" .. "  " .. warning_count .. " ") or ""
  local hint_str = (hint_count and hint_count > 0) and ("%#St_lspHints#" .. "ﯧ " .. hint_count .. " ") or ""
  local info_str = (info_count and info_count > 0) and ("%#St_lspInfo#" .. " " .. info_count .. " ") or ""

  return error_str .. warning_str .. hint_str .. info_str
end

M.options = function()
  -- local left_sep = "%#St_pos_sep#" .. sep_l .. "%#St_pos_icon#" .. "הּ"
  local left_sep = ""
  local text = ""
  if G.languages[vim.bo.filetype] then
    local autoformat = "OFF"
    if G.languages[vim.bo.filetype].autoformat then
      autoformat = "ON"
    end
    text = "[AF=" .. autoformat .. "]"
  end
  if text ~= "" then
    return left_sep .. "%#St_gitIcons#" .. text .. " "
  end
  return ""
end

M.LSP_status = function()
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.attached_buffers[vim.api.nvim_get_current_buf()] then
      return (vim.o.columns > 70 and "%#St_LspStatus#" .. "   LSP ~ " .. client.name .. " ") or "   LSP "
    end
  end
end

M.cwd = function()
  local dir_icon = "%#St_cwd_icon#" .. " "
  local dir_name = "%#St_cwd_text#" .. " " .. fn.fnamemodify(fn.getcwd(), ":t") .. " "
  return (vim.o.columns > 120 and ("%#St_cwd_sep#" .. sep_l .. dir_icon .. dir_name)) or ""
end

M.cursor_position = function()
  local left_sep = "%#St_pos_sep#" .. sep_l .. "%#St_pos_icon#" .. " "

  local current_line = fn.line(".")
  local total_line = fn.line("$")
  local text = math.modf((current_line / total_line) * 100) .. tostring("%%")

  text = (current_line == 1 and "Top") or text
  text = (current_line == total_line and "Bot") or text

  return left_sep .. "%#St_pos_text#" .. " " .. text .. " "
end

M.run = function()
  return table.concat({
    M.mode(),
    M.fileInfo(),
    M.git(),

    "%=",
    M.options(),

    "%=",
    M.LSP_Diagnostics(),
    M.LSP_status() or "",
    M.cursor_position(),
  })
end

return M
