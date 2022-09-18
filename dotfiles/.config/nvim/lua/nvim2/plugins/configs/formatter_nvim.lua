local formatter = require("formatter")
-- Utilities for creating configurations

local config = {
  logging = true,
  log_level = vim.log.levels.ERROR,
  filetype = {
    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace,
    },
  },
}

config.filetype["lua"] = {
  function()
    return {
      exe = "$CONFDIR/formatters/stylua",
      args = {
        "--search-parent-directories",
        "--stdin-filepath",
        require("formatter.util").escape_path(require("formatter.util").get_current_buffer_file_path()),
        "--",
        "-",
      },
      stdin = true,
    }
  end,
}

config.filetype["java"] = {
  function()
    return {
      exe = "java",
      args = { "-jar", "$CONFDIR/formatters/google-java-format.jar", vim.api.nvim_buf_get_name(0) },
      stdin = true,
    }
  end,
}

config.filetype["sh"] = {
  function()
    return {
      exe = "shfmt",
      args = { "-i", "4" },
      stdin = true,
    }
  end,
}

formatter.setup(config)
