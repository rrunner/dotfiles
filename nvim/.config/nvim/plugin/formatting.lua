-- formatting
require("conform").setup({
  -- check conform.log for the actual command/args passed to the formatter etc.
  -- log_level = vim.log.levels.DEBUG,

  formatters = {
    -- ruff_fix:
    --   E501: ensures ruff splits lines (line-length) the same as black
    --   F401: do not remove unused imports (lint rule indicate unused imports still)
    ruff_fix = { append_args = { "--no-preview", "--select=ALL", "--ignore=E501,F401" } },
    prettier = { prepend_args = { "--end-of-line", "auto" } },

    -- sqlfluff:
    --   `sqlfluff dialects` returns available dialects
    --   dialect should match with sql_formatter
    sqlfluff = {
      command = "sqlfluff",
      inherit = false,
      args = { "fix", "--dialect=ansi", "--rules=CP01,CV01", "-" },
    },

    -- sql-formatter:
    --   dialect should match with sqlfluff
    sql_formatter = {
      prepend_args = {
        "-c",
        '{"language": "sql", "tabWidth": 2, "keywordCase": "upper", "dataTypeCase": "upper", "functionCase": "upper", "linesBetweenQueries": 2, "useTabs": false }',
      },
    },

    injected = {
      options = {
        ignore_errors = false,
        lang_to_formatters = {
          sql = { "sql_formatter" },
        },
      },
    },
  },

  -- use lsp fallback to format: toml
  formatters_by_ft = {
    bash = { "shfmt" },
    css = { "prettier" },
    elixir = { "mix" }, -- use system installation of mix (ships with Elixir), e.g. `mix format`
    graphql = { "prettier" },
    haskell = { "ormolu" },
    html = { "prettier" },
    json = { "prettier" },
    lua = { "stylua" },
    markdown = { "prettier", "markdownlint-cli2", "markdown-toc" },
    mojo = { "mojo_format" },
    mysql = { "sqlfluff" },
    python = { "ruff_fix", "ruff_format" },
    quarto = { "injected" },
    r = { "air" }, -- air is a both a formatter and LSP (watch https://posit-dev.github.io/air/editor-neovim.html for capabilities)
    rmd = { "injected" },
    sh = { "shfmt" },
    sql = { "sqlfluff" },
    yaml = { "prettier", "injected" },
  },

  format_after_save = function(bufnr)
    -- remove carriage return characters in linux/wsl on save
    local fileformat = vim.bo.fileformat
    if fileformat ~= "unix" or vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    vim.cmd([[%s/\r//ge]])
  end,
})

vim.keymap.set({ "n", "v" }, "<leader>fr", function()
  require("conform").format({
    async = true,
    lsp_format = "fallback",
  })
end, { desc = "Format buffer/file (or range in visual mode)" })

vim.keymap.set({ "n", "v" }, "<leader>fq", function()
  local retstr = "Configured formatters for buffer"
  local fmt_for_bufnr = require("conform").list_formatters_to_run(0)
  for _, val in ipairs(fmt_for_bufnr) do
    if val.available then
      retstr = retstr .. "\n" .. val.name
    end
  end
  vim.notify(retstr, vim.log.levels.INFO)
end, { desc = "List configured formatters for the current buffer" })
