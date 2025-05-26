local utils = require("config.utils")

return {
  cmd = { utils.app_prio("ty"), "server" },
  root_markers = vim.g.py_root_markers,
  filetypes = { "python" },
  init_options = {
    settings = {
      experimental = {
        completions = {
          enable = false,
        },
      },
      logLevel = "info",
      trace = {
        server = "off",
      },
    },
  },
}
