local utils = require("config.utils")

return {
  cmd = { utils.app_prio("taplo"), "lsp", "stdio" },
  root_markers = { ".toml" },
  filetypes = { "toml" },
}
