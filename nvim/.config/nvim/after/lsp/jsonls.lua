local schemas = Config.utils.schema_settings("json")

return {
  cmd = { "vscode-json-language-server", "--stdio" },
  root_markers = { ".git" },
  filetypes = { "json", "jsonc" },
  init_options = {
    -- use prettier via conform.nvim
    provideFormatter = false,
  },
  settings = {
    json = {
      schemas = schemas,
    },
  },
}
