local utils = require("config.utils")

return {
  cmd = { utils.app_prio("marksman"), "server" },
  filetypes = { "markdown" },
  settings = {},
}
