-- formatting
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    local utl = require("conform.util")
    local formatters = require("conform.formatters")
    local mason_bin_path = vim.fn.stdpath("data") .. "/mason/bin/"

    -- stylua (complete overide of default values)
    conform.formatters.stylua = {
      inherit = false,
      command = mason_bin_path .. "stylua",
      args = {
        "--indent-type",
        "Spaces",
        "--indent-width",
        "2",
        "--search-parent-directories",
        "--stdin-filepath",
        "$FILENAME",
        "-",
      },
    }

    -- sqlfluff (complete overide of default values)
    -- different sql dialects:
    -- ansi, athena, bigquery, clickhouse, databricks, db2,
    -- exasol, hive, mysql, oracle, postgres, redshift,
    -- snowflake, soql, sparksql, sqlite, teradata, tsql
    conform.formatters.sqlfluff = {
      inherit = false,
      command = mason_bin_path .. "sqlfluff",
      args = { "fix", "--force", "--dialect=postgres", "-" },
    }

    -- ruff fix (apply ruff linter fixes)
    -- ruff_organize_imports (select=I001) is already covered by ruff_fix since --select=ALL is used below
    conform.formatters.ruff_fix = {
      command = mason_bin_path .. "ruff",
      args = {
        "check",
        "--fix",
        "--force-exclude",
        "--exit-zero",
        "--no-cache",
        "--select=ALL",
        -- ERA001: ignores messages about code that is commented out
        -- E501: ensures ruff splits lines (line-length) the same as black
        "--ignore=ERA001,E501",
        "--stdin-filename",
        "$FILENAME",
        "-",
      },
      stdin = true,
      cwd = utl.root_file({
        "pyproject.toml",
        "ruff.toml",
        ".ruff.toml",
      }),
    }

    -- ruff format (runs ruff formatter, same as ruff format preset but add it below to enforce mason bin path)
    conform.formatters.ruff_format = {
      command = mason_bin_path .. "ruff",
      args = {
        "format",
        "--force-exclude",
        "--stdin-filename",
        "$FILENAME",
        "-",
      },
      stdin = true,
      cwd = utl.root_file({
        "pyproject.toml",
        "ruff.toml",
        ".ruff.toml",
      }),
    }

    -- sql-formatter
    -- different sql dialects:
    -- bigquery,db2,db2i,hive,mariadb,mysql,n1ql,plsql,postgresql,
    -- redshift,singlestoredb,snowflake,spark,sql,sqlite,transactsql,trino,tsql
    conform.formatters.sql_formatter = {
      command = mason_bin_path .. "sql-formatter",
      prepend_args = {
        "-c",
        '{"language": "postgresql", "tabWidth": 2, "keywordCase": "upper", "dataTypeCase": "upper", "functionCase": "upper", "linesBetweenQueries": 2, "useTabs": false }',
      },
    }

    -- injected
    conform.formatters.injected = {
      options = {
        ignore_errors = false,
        lang_to_formatters = {
          sql = { "sql_formatter" },
        },
      },
    }

    -- prefer formatters installed by mason
    formatters.prettier.command = mason_bin_path .. "prettier"
    formatters.shfmt.command = mason_bin_path .. "shfmt"

    conform.setup({
      -- use lsp fallback to format: r, rmd, toml
      -- use stop_after_first = true to use the first found formatter if the table includes several formatters
      formatters_by_ft = {
        -- TODO: use ruff LSP for python formatting to enable config via pyproject.toml (ruff format via ruff LSP currently don't cover all use cases)
        python = { "ruff_fix", "ruff_format" }, -- run both for now... see https://github.com/astral-sh/ruff/issues/8232
        lua = { "stylua" },
        markdown = { "prettier", "injected" },
        quarto = { "injected" }, -- TODO: format R code blocks in quarto document
        yaml = { "prettier", "injected" },
        json = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        graphql = { "prettier" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        sql = { "sqlfluff" },
        mysql = { "sqlfluff" },
      },
      format_after_save = function(bufnr)
        -- remove carriage return characters in linux/wsl on save
        local fileformat = vim.opt_local.fileformat:get()
        if fileformat ~= "unix" or vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        vim.cmd([[%s/\r//ge]])
      end,
    })

    vim.keymap.set({ "n", "v" }, "<leader>fr", function()
      conform.format({
        async = true,
        lsp_format = "fallback",
      })
    end, { desc = "Format buffer/file (or range in visual mode)" })

    vim.keymap.set({ "n", "v" }, "<leader>fq", function()
      local retstr = "Configured formatters for buffer"
      local fmt_for_bufnr = conform.list_formatters_to_run(0)
      for _, val in ipairs(fmt_for_bufnr) do
        if val.available then
          retstr = retstr .. "\n" .. val.name
        end
      end
      vim.notify(retstr, vim.log.levels.INFO)
      -- end
    end, { desc = "List configured formatters for the current buffer" })
  end,
}
