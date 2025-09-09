local utils = require("config.utils")

return {
  cmd = { utils.app_prio("ruff"), "server" },
  root_markers = vim.g.py_root_markers,
  filetypes = { "python" },
  init_options = {
    settings = {
      configurationPreference = "filesystemFirst",
      lint = {
        enable = true,
        preview = false,
        select = { "ALL" },
        ignore = {
          "D406",
          "D407",
          "E501",
          "ERA",
          "ERA001",
          "PD901",
          "PLR0913",
          "PLR2004",
          "RET504",
          "T100",
          "T201",
        },
      },
      exclude = {
        ".eggs",
        ".git",
        ".mypy_cache",
        ".pyenv",
        ".pytest_cache",
        ".pytype",
        ".ruff_cache",
        ".venv",
        ".vscode-oss/",
        ".vscode/",
        "Dropbox/",
        "build",
        "dist",
        "node_modules",
        "projects/",
        "site-packages",
        "venv",
      },
      lineLength = 88,
      fixAll = false,
      organizeImports = false,
      showSyntaxErrors = true,
      logLevel = "error",
    },
  },
  -- disable ruff as hover provider to avoid conflicts with pyright
  -- maybe not required for ruff + ty
  on_attach = function(client)
    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end
  end,
}
