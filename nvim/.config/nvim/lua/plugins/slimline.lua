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
          "mode",
          "path",
          "git",
          "diagnostics",
        },
        center = {},
        right = {
          utils.venv_with_cwd(false),
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
            branch = icons.git_icons.conflict,
            added = icons.git_icons.added,
            modified = icons.git_icons.modified,
            removed = icons.git_icons.deleted,
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
        filetype_lsp = {
          map_lsps = {
            ["basedpyright"] = "bpyright",
          },
        },
      },
      disabled_filetypes = {
        "help",
        "lazy",
        "mason",
        "snacks_picker_input",
        "snacks_picker_list",
        "snacks_terminal",
      },
    }
    require("slimline").setup(opts)
  end,
}
