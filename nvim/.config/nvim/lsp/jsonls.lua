local utils = require("config.utils")

local settings = function()
  if not utils.IS_GITHUB_BLOCKED then
    -- schemastore supports local schemas, see "extra" argument to json.schemas()
    local schemas = require("schemastore").json.schemas()
    return schemas
  else
    return {}
  end
end

local schemas = settings()

return {
  cmd = { utils.app_prio("vscode-json-language-server"), "--stdio" },
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
