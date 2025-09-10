local utils = require("config.utils")

return {
  cmd = { utils.app_prio("ruff"), "server" },
  root_markers = vim.g.py_root_markers,
  filetypes = { "python" },
  init_options = {
    settings = {
      lint = {
        enable = true,
      },
      lineLength = 88,
      fixAll = false,
      organizeImports = false,
      showSyntaxErrors = true,
      logLevel = "error",
      configurationPreference = "filesystemFirst",
      -- configuration = "~/dotfiles/python_tooling/pyproject.toml",
      configuration = {
        lint = {
          preview = false,
          ["future-annotations"] = true,
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
        -- formatting using ruff CLI with conform.nvim (see on_attach below)
        format = {
          preview = false,
        },
      },
      codeAction = {
        disableRuleComment = {
          enable = true,
        },
        fixViolation = {
          enable = true,
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
    },
  },
  on_attach = function(client)
    if client.name == "ruff" then
      -- disable ruff as hover provider to avoid conflicts with ty
      -- client.server_capabilities.hoverProvider = false
      -- formatting using ruff CLI with conform.nvim
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
  end,
}
