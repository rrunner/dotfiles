-- mason
return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  cond = function()
    local utils = require("config.utils")
    return utils.IS_GITHUB_BLOCKED_INVERSE_BOOL
  end,
  config = function()
    local utils = require("config.utils")

    require("mason").setup({
      ui = {
        keymaps = {
          toggle_package_expand = "o",
          toggle_package_install_log = "o",
        },
      },
    })

    -- LSP servers
    local lsp_servers = {
      "pyright",
      "basedpyright",
      "ruff",
      "r-languageserver", --r_language_server
      "lua-language-server", --lua_ls
      "yaml-language-server", --yamlls
      "dockerfile-language-server", --dockerls
      "taplo",
      "bash-language-server", --bashls
      "sqlls",
      "marksman",
      "json-lsp",
    }

    -- linters, formatters, debuggers etc.
    local tools = {
      -- "debugpy",
      "jq",
      "markdown-toc",
      "markdownlint-cli2",
      "mypy",
      "prettier",
      "ruff",
      "shfmt",
      "sql-formatter",
      "sqlfluff",
      "stylua",
      "vale",
    }
    local ensure_installed = utils.unique_values(lsp_servers, tools)
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
  end,
}
