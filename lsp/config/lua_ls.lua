return {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "hs" },
      },
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        },
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
