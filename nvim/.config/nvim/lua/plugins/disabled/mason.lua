-- mason
return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
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

    local lsps = {
      "pyright",
      "lua_ls",
      "dockerls",
      "texlab",
      "r_language_server",
      "sqlls",
      "taplo",
      "yamlls",
      "bashls",
      "terraformls",
      "ruff",
      "basedpyright",
    }

    -- need terraform system installation in WSL (currently not important)
    if utils.IS_WSL then
      utils.remove_value(lsps, { "terraformls" })
    end

    require("mason-lspconfig").setup({
      ensure_installed = lsps,
      automatic_installation = true,
    })

    require("mason-tool-installer").setup({
      ensure_installed = {
        "black",
        "debugpy",
        "jq",
        "mypy",
        "prettier",
        "ruff",
        "shfmt",
        "sql-formatter",
        "sqlfluff",
        "stylua",
      },
    })
  end,
}
