return {
  cmd = { Config.utils.app_prio("sql-language-server"), "up", "--method", "stdio" },
  filetypes = { "sql", "mysql" },
  settings = {},
}
