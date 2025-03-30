local utils = require("config.utils")

return {
  cmd = { utils.app_prio("vscode-json-language-server"), "--stdio" },
  filetypes = { "json", "jsonc" },
  settings = {
    init_options = {
      provideFormatter = true,
    },
  },
}
