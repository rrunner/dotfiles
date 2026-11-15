return {
  cmd = { "harper-ls", "--stdio" },
  root_markers = { ".harper-dictionary.txt", ".git" },
  filetypes = { "gitcommit", "markdown", "mail", "text", "quarto" },
  settings = {
    ["harper-ls"] = {
      -- userDictPath = "~/dict.txt",
      linters = {
        SentenceCapitalization = true,
        SpellCheck = false,
      },
    },
  },
}
