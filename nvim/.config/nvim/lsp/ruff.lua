local utils = require("config.utils")

return {
  cmd = { utils.app_prio("ruff"), "server" },
  root_markers = vim.g.py_root_markers,
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
