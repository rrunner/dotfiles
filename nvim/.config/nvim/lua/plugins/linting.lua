return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    local utils = require("config.utils")

    -- mypy only works with stdin = false (only updates for event BufWritePost in the autocmd below)
    lint.linters.mypy.cmd = utils.app_prio("mypy")

    -- sqlfluff
    -- different sql dialects:
    -- "ansi", "athena", "bigquery", "clickhouse", "databricks", "db2",
    -- "duckdb", "exasol", "greenplum", "hive", "materializ", "mysql",
    -- "oracle", "postgres", "redshift", "snowflake", "soql", "sparksql",
    -- "sqlite", "teradata", "trino", "tsql"
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
        lint.try_lint()
      end,
      group = linter_augroup,
    })
  end,
}
