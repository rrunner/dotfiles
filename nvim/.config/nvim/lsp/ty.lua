local utils = require("config.utils")

return {
  cmd = { utils.app_prio("ty"), "server" },
  root_markers = vim.g.py_root_markers,
  filetypes = { "python" },
  settings = {
    init_options = {
      -- logFile = "~/ty.log",
      -- logLevel = "debug",
    },
    ty = {
      disableLanguageServices = false,
      diagnosticMode = "workspace",
      inlayHints = {
        variableTypes = true,
        callArgumentNames = true,
      },
      experimental = {
        rename = true,
        autoImport = true,
      },
    },
  },
}
