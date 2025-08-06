local utils = require("config.utils")

return {
  cmd = { utils.app_prio("tombi"), "lsp" },
  root_markers = { "tombi.toml", "pyproject.toml", ".git" },
  filetypes = { "toml" },
}
