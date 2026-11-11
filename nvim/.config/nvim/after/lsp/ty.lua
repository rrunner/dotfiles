return {
  cmd = { "ty", "server" },
  root_markers = vim.g.py_root_markers,
  filetypes = { "python" },
  init_options = {
    -- logFile = "~/ty.log",
    -- logLevel = "debug",
    experimental = {
      -- uv/ty integration: no uv/ty integration ("off"), uv/ty integration for
      -- PEP723 scripts ("scripts") and script and uv project discovery ("on")
      useUv = "off",
    },
  },
  settings = {
    ty = {
      disableLanguageServices = false,
      diagnosticMode = "workspace",
      showSyntaxErrors = false, -- ruff displays syntax errors
      inlayHints = {
        variableTypes = true,
        callArgumentNames = true,
      },
      completions = {
        autoImport = true,
        completeFunctionParentheses = true,
      },
      -- configurationFile = "./.config/ty.toml",
      -- inline settings always take precedence over the settings from configuration files (incl. configurationFile)
      -- configuration = {
      --   rules = {
      --     ["unresolved-reference"] = "warn",
      --   },
      -- },
    },
  },
}
