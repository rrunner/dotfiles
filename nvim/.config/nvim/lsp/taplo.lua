local utils = require("config.utils")

return {
  cmd = { utils.app_prio("taplo"), "lsp", "stdio" },
  root_markers = { ".taplo.toml", "taplo.toml", ".git" },
  filetypes = { "toml" },
  settings = {
    evenBetterToml = {
      include = {
        paths = { "**/*.toml" },
      },
      formatter = {
        compactEntries = false,
        allowedBlankLines = 1,
      },
    },
  },
  workspace_required = false, -- single file support
}
