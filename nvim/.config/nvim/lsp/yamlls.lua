local utils = require("config.utils")

return {
  cmd = { utils.app_prio("yaml-language-server"), "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
  settings = {
    redhat = {
      telemetry = {
        enabled = false,
      },
    },
    hover = true,
    completion = true,
    validate = true,
  },
}
