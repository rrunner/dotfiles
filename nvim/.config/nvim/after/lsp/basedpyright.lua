return {
  cmd = { Config.utils.app_prio("basedpyright-langserver", { python_tool = true }), "--stdio" },
  root_markers = vim.g.py_root_markers,
  filetypes = { "python" },
  settings = {
    basedpyright = {
      analysis = {
        diagnosticMode = "workspace",
        typeCheckingMode = "recommended",
        typeshedPaths = { "" },
        -- ignore all files for analysis to exclusively use Ruff for linting and ty for type checking
        ignore = { "*" },
      },
      -- use ruff cli (conform) to format imports
      disableOrganizeImports = true,
    },
    python = {
      venvPath = vim.env.VIRTUAL_ENV,
    },
  },
}
