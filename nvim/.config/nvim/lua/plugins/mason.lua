-- mason
return {
  "mason-org/mason.nvim",
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

    -- disable cursorline for Mason
    local mason_augroup = vim.api.nvim_create_augroup("Mason", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(event)
        local buffers_no_cursorline = { "mason" }
        if vim.tbl_contains(buffers_no_cursorline, vim.bo[event.buf].filetype) then
          vim.opt_local.cursorline = false
        end
      end,
      group = mason_augroup,
      pattern = "*",
    })

    -- LSP servers
    local lsp_servers = {
      "basedpyright",
      "bash-language-server", --bashls
      "dockerfile-language-server", --dockerls
      "json-lsp",
      "lua-language-server", --lua_ls
      "marksman",
      "pyright",
      "r-languageserver", --r_language_server
      "ruff",
      "sqlls",
      "taplo",
      "ty",
      "yaml-language-server", --yamlls
    }

    -- linters, formatters, debuggers etc.
    local tools = {
      "air",
      "debugpy",
      "hlint",
      "jq",
      "markdown-toc",
      "markdownlint-cli2",
      "mypy",
      "ormolu",
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
