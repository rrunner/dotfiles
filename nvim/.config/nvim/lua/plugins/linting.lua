return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    local mason_bin_path = vim.fn.stdpath("data") .. "/mason/bin/"

    -- modify linters

    -- ruff updates for all events specified in the autocmd below
    local function get_file_name()
      return vim.api.nvim_buf_get_name(0)
    end

    lint.linters.ruff.cmd = mason_bin_path .. "ruff"

    lint.linters.ruff.args = {
      "check",
      "--select=ALL", -- aggressive setting
      -- RET504: unnecessary assignment before return statement
      -- PLR2004: use of magic constant values
      -- PD901: use of name df with pandas
      -- PLR0913: more than 5 arguments to a function
      "--ignore=D407,T201,ERA,D406,RET504,PLR2004,PD901,PLR0913",
      "--force-exclude",
      "--quiet",
      "--stdin-filename",
      get_file_name,
      "--no-fix",
      "--output-format",
      "json",
      "-",
    }

    -- mypy only works with stdin = false (only updates for event BufWritePost in the autocmd below)
    lint.linters.mypy.cmd = mason_bin_path .. "mypy"
    lint.linters.mypy.args = {
      -- "--strict", -- aggressive setting
      "--ignore-missing-imports",
      "--follow-imports=silent",
      "--show-column-numbers",
      "--show-error-end",
      "--hide-error-codes",
      "--hide-error-context",
      "--no-color-output",
      "--no-error-summary",
      "--no-pretty",
    }

    -- sqlfluff
    -- different sql dialects:
    -- "ansi", "athena", "bigquery", "clickhouse", "databricks", "db2",
    -- "duckdb", "exasol", "greenplum", "hive", "materializ", "mysql",
    -- "oracle", "postgres", "redshift", "snowflake", "soql", "sparksql",
    -- "sqlite", "teradata", "trino", "tsql"
    lint.linters.sqlfluff.cmd = mason_bin_path .. "sqlfluff"
    lint.linters.sqlfluff.args = { "lint", "--dialect", "postgres" }

    lint.linters_by_ft = {
      python = { "ruff", "mypy" },
      sql = { "sqlfluff" },
      mysql = { "sqlfluff" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufReadPost", "InsertLeave", "BufWritePost", "TextChanged" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
