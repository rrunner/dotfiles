-- mason
return {
  "mason-org/mason.nvim",
  build = ":MasonUpdate",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  cond = function()
    return vim.g.is_github_not_blocked
  end,
  config = function()
    local utils = require("config.utils")

    require("mason").setup({
      ui = {
        width = 0.8,
        height = 0.9,
        border = "none",
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
          vim.wo.cursorline = false
        end
      end,
      group = mason_augroup,
      pattern = "*",
    })

    -- LSP servers
    local lsp_servers = {
      "bash-language-server", --bashls
      "dockerfile-language-server", --dockerls
      "json-lsp",
      "lua-language-server", --lua_ls
      "r-languageserver", --r_language_server
      "ruff",
      "sqlls",
      "tombi",
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
      "ormolu",
      "prettier",
      "ruff",
      "shfmt",
      "sql-formatter",
      "sqlfluff",
      "stylua",
      "vale",
    }
    -- TODO: in nvim 0.12
    -- 1. concatenate these two tables using vim.tbl_extend("keep", lsp_servers, tools)
    -- 2. use vim.list.unique() to select unique items
    -- 3. remove utils.unique_values
    local ensure_installed = utils.unique_values(lsp_servers, tools)
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
  end,
}
