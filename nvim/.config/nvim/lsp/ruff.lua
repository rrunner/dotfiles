local utils = require("config.utils")

return {
  cmd = { utils.app_prio("ruff"), "server" },
  root_markers = {
    "requirements.txt",
    "pyproject.toml",
    "pyrightconfig.json",
    "Pipfile",
    "uv.lock",
  },
  filetypes = { "python" },
  init_options = {
    settings = { logLevel = "error" },
  },
  -- disable ruff as hover provider to avoid conflicts with pyright
  on_attach = function(client)
    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end
  end,
}
