-- treesitter
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    -- "nvim-treesitter/nvim-treesitter-textobjects",
    { "PMassicotte/nvim-treesitter-textobjects", branch = "fix-new-r-parser" },
    "nvim-treesitter/nvim-treesitter-context",
  },
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")
    local utils = require("config.utils")

    -- dap-repl-highlights is configured in dap.lua (must be installed from within an active debugger session)
    local ts_parsers = {
      "bash",
      "bibtex",
      "c",
      "csv",
      "dap_repl",
      "diff",
      "dockerfile",
      "editorconfig",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "graphql",
      "http",
      "hurl",
      "json",
      "jsonc",
      "latex",
      "lua",
      "markdown",
      "markdown_inline",
      "ninja",
      "psv",
      "python",
      "query",
      "r",
      "regex",
      "rst",
      "sql",
      "terraform",
      "toml",
      "tsv",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    }

    -- jsonc does not install on WSL (do not know why...)
    if utils.IS_WSL then
      utils.remove_value(ts_parsers, { "jsonc" })
    end

    configs.setup({
      ensure_installed = ts_parsers,
      sync_install = false,
      auto_install = false,
      ignore_install = { "" },
      highlight = {
        enable = true,
        disable = { "" },
      },
      indent = {
        enable = true,
        disable = {},
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "+",
          node_incremental = "+",
          node_decremental = "_",
          -- scope_incremental = "<c-s>",
        },
      },
      -- nvim-treesitter-textobjects module specific settings
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = false,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]]"] = "@class.outer",
            ["]a"] = "@parameter.inner",
          },
          -- goto_next_end = {
          --   ["]F"] = "@function.outer",
          --   ["]["] = "@class.outer",
          -- },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[["] = "@class.outer",
            ["[a"] = "@parameter.inner",
          },
          -- goto_previous_end = {
          --   ["[F"] = "@function.outer",
          --   ["[]"] = "@class.outer",
          -- },
        },
      },
    })
    -- treesitter context
    require("treesitter-context").setup({
      multiline_threshold = 1,
    })
  end,
}
