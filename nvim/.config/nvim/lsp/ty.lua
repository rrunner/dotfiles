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
      completions = {
        autoImport = true,
      },
      -- configurationFile = "./.config/ty.toml",
      -- inline settings always take precedence over the settings from configuration files (incl. configurationFile)
      -- configuration = {
      --   rules = {
      --     ["unresolved-reference"] = "warn",
      --   },
      -- },
    },
  },
}
