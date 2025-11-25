local utils = require("config.utils")

return {
  cmd = { utils.app_prio("harper-ls"), "--stdio" },
  root_markers = { ".git" },
  filetypes = { "gitcommit", "markdown", "mail", "text" },
  settings = {
    ["harper-ls"] = {
      -- userDictPath = "~/dict.txt",
      linters = {
        SentenceCapitalization = true,
        SpellCheck = false,
      },
    }
  },
}
