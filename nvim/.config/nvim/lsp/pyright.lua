local utils = require("config.utils")

return {
  cmd = { utils.app_prio("pyright-langserver"), "--stdio" },
  root_markers = {
    "requirements.txt",
    "pyproject.toml",
    "pyrightconfig.json",
    "Pipfile",
  },
  filetypes = { "python" },
  settings = {
    pyright = {
      -- use Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        -- set to "openFilesOnly" if pyright is slow or if the virtual environment is large
        -- alternatively, try to comment "venv" and "venvPath" in pyproject.toml in section [tools.pyright]
        diagnosticMode = "workspace",
        typeCheckingMode = "strict",
        -- ignore all files for analysis to exclusively use Ruff for linting, and mypy for type checking if in use
        ignore = { "*" },
      },
      venvPath = vim.env.VIRTUAL_ENV,
    },
  },
}
