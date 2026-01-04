-- linting
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- sqlfluff (see 'sqlfluff dialects' for different dialects)
    lint.linters.sqlfluff.args = { "lint", "--format=json", "--dialect", "ansi" }

    lint.linters_by_ft = {
      -- `mix credo` is installed on project basis as a mix dependency
      elixir = { "credo" },
      haskell = { "hlint" },
      markdown = { "markdownlint-cli2", "vale" },
      mysql = { "sqlfluff" },
      sql = { "sqlfluff" },
    }

    local linter_augroup = vim.api.nvim_create_augroup("Linting", { clear = true })
    vim.api.nvim_create_autocmd({ "BufReadPost", "InsertLeave", "BufWritePost", "TextChanged" }, {
      callback = function()
        if vim.bo.modifiable then
          lint.try_lint()
        end
      end,
      group = linter_augroup,
    })
  end,
}
