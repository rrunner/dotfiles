return {
  "sschleemilch/slimline.nvim",
  dependencies = {
    { "echasnovski/mini.icons", version = false },
  },
  config = function()
    local utils = require("config.utils")
    local icons = require("config.icons")

    local opts = {
      style = "fg",
      components = {
        left = {
          function()
            return ""
          end,
          -- "mode",
          "path",
          "git",
          "diagnostics",
        },
        center = {},
        right = {
          utils.venv_with_cwd,
          "filetype_lsp",
          "progress",
        },
      },
      configs = {
        mode = {
          verbose = false,
        },
        path = {
          directory = false,
        },
        git = {
          icons = {
            branch = "",
            added = "+",
            modified = "~",
            removed = "-",
          },
        },
        diagnostics = {
          icons = {
            ERROR = icons.diagnosis.error .. " ",
            WARN = icons.diagnosis.warn .. " ",
            INFO = icons.diagnosis.info .. " ",
            HINT = icons.diagnosis.hint .. " ",
          },
        },
      },
    }
    require("slimline").setup(opts)
  end,
}
