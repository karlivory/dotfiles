return {
  server = astronvim.lsp.server_settings "rust_analyzer",
  tools = {
    inlay_hints = {
      -- TODO: toggle inlay hints via require('rust-tools').inlay_hints.enable() and [..].disable()
      -- disabled for now, since it's distracting
      auto = false,
      parameter_hints_prefix = "  ",
      other_hints_prefix = "  ",
    },
  },
}
