-- formatting
return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local utils = require("config.utils")
    local conform = require("conform")
    local utl = require("conform.util")

    -- stylua (complete overide of default values)
    conform.formatters.stylua = {
      inherit = false,
      command = utils.app_prio("stylua"),
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
      command = utils.app_prio("sqlfluff"),
      inherit = false,
      args = { "fix", "--dialect=postgres", "-" },
    }

    -- ruff fix (apply ruff linter fixes)
    -- ruff_organize_imports (select=I001) is already covered by ruff_fix since --select=ALL is used below
    conform.formatters.ruff_fix = {
      command = utils.app_prio("ruff"),
      args = {
        "check",
        "--fix",
        "--force-exclude",
        "--exit-zero",
        "--no-cache",
        "--no-preview",
        "--select=ALL",
        -- ERA001: ignores messages about code that is commented out
        -- E501: ensures ruff splits lines (line-length) the same as black
        -- F401: do not remove unused imports (lint rule indicate unused imports still)
        "--ignore=ERA001,E501,F401",
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

    -- ruff format (runs ruff formatter, same as ruff format preset)
    conform.formatters.ruff_format = {
      command = utils.app_prio("ruff"),
      args = {
        "format",
        "--force-exclude",
        -- example of inline TOML (key-value) configuration options
        -- note: get the configuration name/key from the CLI tool and not from pyproject.toml
        -- "--config",
        -- [[format.quote-style='double']],
        -- "--line-length",
        -- "88",
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

    conform.formatters.prettier = {
      prepend_args = { "--end-of-line", "auto" },
    }

    -- sql-formatter (different sql dialects available)
    conform.formatters.sql_formatter = {
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

    conform.setup({
      -- use lsp fallback to format: toml
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
        lua = { "stylua" },
        markdown = { "prettier", "markdownlint-cli2", "markdown-toc" },
        quarto = { "injected" },
        yaml = { "prettier", "injected" },
        json = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        graphql = { "prettier" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        sql = { "sqlfluff" },
        mysql = { "sqlfluff" },
        haskell = { "ormolu" },
        -- TODO: air is a both a formatter and LSP
        -- watch https://posit-dev.github.io/air/editor-neovim.html for capabilities
        r = { "air" },
        rmd = { "injected" },
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
    end, { desc = "List configured formatters for the current buffer" })
  end,
}
