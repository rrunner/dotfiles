local utils = require("config.utils")

return {
  cmd = { utils.app_prio("bash-language-server"), "start" },
  filetypes = { "sh", "bash" },
  settings = {
    bashIde = {
      enableSourceErrorDiagnostics = true,
      shellcheckArguments = {
        "-e",
        "SC2086",
        "-e",
        "SC2155",
      },
    },
  },
}
