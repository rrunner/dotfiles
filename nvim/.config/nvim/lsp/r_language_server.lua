local utils = require("config.utils")

return {
  cmd = { utils.app_prio("r-languageserver") },
  filetypes = { "r", "rmd" },
}
