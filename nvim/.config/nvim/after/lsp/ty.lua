-- uv/ty integration and PEP723 settings
local ty_settings = (function()
  if vim.g.python_uv_ty_script == "script" then
    return { useUv = "scripts", diagnosticMode = "openFilesOnly", script = "uv" }
  end
  return { useUv = "off", diagnosticMode = "workspace", script = "none" }
end)()

return {
  cmd = { "ty", "server" },
  root_markers = vim.g.py_root_markers,
  filetypes = { "python" },
  init_options = {
    -- logFile = "~/ty.log",
    -- logLevel = "debug",
    experimental = {
      useUv = ty_settings.useUv, -- uv/ty integration: "off" or "scripts" or "on"
    },
  },
  settings = {
    ty = {
      disableLanguageServices = false,
      diagnosticMode = ty_settings.diagnosticMode, -- use for PEP723 scripts to limit type checking to the current file
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
      configuration = {
        -- rules = {
        --   ["unresolved-reference"] = "warn",
        -- },
        ["project-manager"] = {
          project = "uv",
          script = ty_settings.script, -- "uv" or "none" to enable/disable PEP723 scripts
        },
      },
    },
  },
}
