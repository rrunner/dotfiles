local utils = require("config.utils")

return {
  cmd = { utils.app_prio("r-languageserver") },
  filetypes = { "r", "rmd", "quarto" },
  on_attach = function(client, _)
    -- use air for formatting
    -- air is a both a formatter and LSP: watch https://posit-dev.github.io/air/editor-neovim.html for capabilities
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, ".git") or vim.uv.os_homedir())
  end,
}
