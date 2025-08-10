local utils = require("config.utils")

return {
  cmd = { utils.app_prio("ty"), "server" },
  root_markers = vim.g.py_root_markers,
  filetypes = { "python" },
  settings = {
    ty = {
      disableLanguageServices = true,
      diagnosticMode = "workspace",
    },
    init_options = {
      -- logFile = "~/ty.log",
      logLevel = "debug",
    },
  },
}
