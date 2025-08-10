local utils = require("config.utils")

local settings = function()
  if vim.g.is_github_not_blocked then
    local schemas = require("schemastore").yaml.schemas()
    return schemas
  else
    return {}
  end
end

local schemas = settings()

return {
  cmd = { utils.app_prio("yaml-language-server"), "--stdio" },
  root_markers = { ".git" },
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
  settings = {
    redhat = {
      telemetry = {
        enabled = false,
      },
    },
    yaml = {
      hover = true,
      completion = true,
      validate = true,
      format = {
        -- use prettier via conform.nvim since LSP formatter cannot handle injected languages
        enable = false,
      },
      schemaStore = {
        -- disable built-in schemaStore support (e.g. use schemastore plugin instead)
        enable = false,
        -- avoid TypeError
        url = "",
      },
      schemas = schemas,
      trace = {
        server = "off",
      },
    },
  },
}
