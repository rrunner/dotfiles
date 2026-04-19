-- slimline
require("slimline").setup({
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
      Config.utils.venv_with_cwd,
      "filetype_lsp",
      "recording",
      "progress",
    },
  },
  configs = {
    mode = {
      verbose = false,
    },
    path = {
      directory = false,
      truncate = {
        chars = 1,
        full_dirs = 2,
      },
      icons = {
        modified = "+",
        read_only = "ro",
      },
    },
    git = {
      icons = {
        branch = Config.icons.git_icons.conflict,
        added = Config.icons.git_icons.added,
        modified = Config.icons.git_icons.modified,
        removed = Config.icons.git_icons.deleted,
      },
    },
    diagnostics = {
      icons = {
        ERROR = Config.icons.diagnosis.error .. " ",
        WARN = Config.icons.diagnosis.warn .. " ",
        INFO = Config.icons.diagnosis.info .. " ",
        HINT = Config.icons.diagnosis.hint .. " ",
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
    "mason",
    "snacks_picker_input",
    "snacks_picker_list",
    "snacks_terminal",
  },
})
