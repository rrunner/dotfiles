return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    local utils = require("config.utils")

    -- mypy only works with stdin = false (only updates for event BufWritePost in the autocmd below)
    lint.linters.mypy.cmd = utils.app_prio("mypy")

    -- sqlfluff (see 'sqlfluff dialects' for different dialects)
    lint.linters.sqlfluff.cmd = utils.app_prio("sqlfluff")
    lint.linters.sqlfluff.args = { "lint", "--dialect", "postgres" }

    lint.linters_by_ft = {
      python = { "mypy" }, -- use ruff LSP for python linting to enable config via pyproject.toml
      sql = { "sqlfluff" },
      mysql = { "sqlfluff" },
      markdown = { "markdownlint-cli2" },
    }

    local linter_augroup = vim.api.nvim_create_augroup("Linting", { clear = true })
    vim.api.nvim_create_autocmd({ "BufReadPost", "InsertLeave", "BufWritePost", "TextChanged" }, {
      callback = function()
        -- run the linter in buffers that you can modify
        if vim.opt_local.modifiable:get() then
          lint.try_lint()
        end
      end,
      group = linter_augroup,
    })
  end,
}
