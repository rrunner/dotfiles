local utils = require("config.utils")

return {
  cmd = { utils.app_prio("sql-language-server"), "up", "--method", "stdio" },
  filetypes = { "sql", "mysql" },
  settings = {},
}
