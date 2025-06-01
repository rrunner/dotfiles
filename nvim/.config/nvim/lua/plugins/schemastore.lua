-- plugin that provides the SchemaStore catalog for use with jsonls and yamlls
utils = require("config.utils")

return {
  "b0o/schemastore.nvim",
  cond = function()
    return not utils.IS_GITHUB_BLOCKED
  end,
  ft = { "json", "jsonc", "yaml", "yaml.docker-compose", "yaml.gitlab" },
}
