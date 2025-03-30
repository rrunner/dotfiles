local utils = require("config.utils")

return {
  cmd = { utils.app_prio("basedpyright-langserver"), "--stdio" },
  root_markers = {
    "requirements.txt",
    "pyproject.toml",
    "pyrightconfig.json",
    "Pipfile",
  },
  filetypes = { "python" },
  settings = {
    basedpyright = {
      analysis = {
        diagnosticMode = "workspace",
        typeCheckingMode = "all",
        -- ignore all files for analysis to exclusively use Ruff for linting, and mypy for type checking if in use
        ignore = { "*" },
      },
      disableOrganizeImports = true, --ruff formats imports
    },
    python = {
      venvPath = vim.env.VIRTUAL_ENV,
    },
  },
}
