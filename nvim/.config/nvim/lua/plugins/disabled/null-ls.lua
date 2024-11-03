--null-ls
return {
  "jose-elias-alvarez/null-ls.nvim",
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "jay-babu/mason-null-ls.nvim",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = {
        "williamboman/mason.nvim",
        "jose-elias-alvarez/null-ls.nvim",
      },
      config = function()
        require("mason-null-ls").setup({
          ensure_installed = {
            -- python related
            "black",
            "ruff",
            "mypy",
            -- "debugpy",
            -- R related
            "styler",
            -- lua related
            "stylua",
            -- other
            "prettier",
            "sqlfluff",
            "shfmt",
            -- "terraform_fmt", -- currently requires system installation
          },
          automatic_installation = true,
        })
      end,
    },
  },
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    local mason_bin_path = vim.fn.stdpath("data") .. "/mason/bin/"

    null_ls.setup({
      debug = false,
      sources = {
        formatting.prettier.with({
          command = { mason_bin_path .. "prettier" },
          filetype = {
            "css",
            "html",
            "yaml",
            "markdown",
            "graphql",
          },
        }),
        formatting.black.with({
          command = { mason_bin_path .. "black" },
          filetype = { "python" },
        }),
        -- formatting.isort.with({
        --   filetype = { "python" },
        -- }),
        formatting.ruff.with({
          filetype = { "python" },
          command = { mason_bin_path .. "ruff" },
          args = { "--fix", "-e", "-n", "--stdin-filename", "$FILENAME", "-" },
          extra_args = { "--select", "ALL", "--ignore", "D407,T201,ERA,D406,PLR2004" },
        }),
        formatting.styler.with({
          filetype = { "r" },
        }),
        formatting.stylua.with({
          command = { mason_bin_path .. "stylua" },
          filetype = { "lua" },
          extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        }),
        formatting.sqlfluff.with({
          filetype = { "sql", "mysql" },
          command = { mason_bin_path .. "sqlfluff" },
          args = { "fix", "--disable-progress-bar", "-f", "-n", "-" },
          -- different sql dialects:
          -- "ansi", "athena", "bigquery", "clickhouse", "databricks", "db2", "exasol", "hive", "mysql", "oracle",
          -- "postgres", "redshift", "snowflake", "soql", "sparksql", "sqlite", "teradata", "tsql"
          extra_args = { "--dialect", "postgres" },
        }),
        formatting.shfmt.with({
          filetype = { "sh", "bash" },
          command = { mason_bin_path .. "shfmt" },
          -- args = { "-filename", "$FILENAME" },
        }),
        formatting.terraform_fmt.with({
          filetype = { "terraform", "tf", "terraform-vars" },
          command = { "terraform" },
          args = { "fmt", "-" },
        }),
        diagnostics.mypy.with({
          filetype = { "python" },
          command = { mason_bin_path .. "mypy" },
          diagnostics_format = "[#{c}] #{m} (#{s})",
        }),
        -- diagnostics.flake8.with({
        --   filetype = { "python" },
        --   diagnostics_format = "[#{c}] #{m} (#{s})",
        -- }),
        -- diagnostics.pylint.with({
        --   filetype = { "python" },
        --   extra_args = { "--disable=R0903, C0103" },
        --   diagnostics_format = "[#{c}] #{m} (#{s})",
        -- }),
        -- diagnostics.pydocstyle.with({
        --   filetype = { "python" },
        --   diagnostics_format = "[#{c}] #{m} (#{s})",
        -- }),
        diagnostics.ruff.with({
          filetype = { "python" },
          command = { mason_bin_path .. "ruff" },
          diagnostics_format = "[#{c}] #{m} (#{s})",
          args = { "-n", "-e", "--stdin-filename", "$FILENAME", "-" },
          extra_args = { "--select", "ALL", "--ignore", "D407,T201,ERA,D406" },
        }),
        null_ls.builtins.code_actions.gitsigns,
      },
    })
  end,
}
