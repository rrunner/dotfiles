return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = {
      enabled = true,
      notify = true,
      size = 1.5 * 1024 * 1024,
    },
    bufdelete = { enabled = false },
    debug = { enabled = false },
    git = { enabled = false },
    gitbrowse = { enabled = false },
    lazygit = { enabled = false },
    notify = { enabled = false },
    notifier = { enabled = false },
    quickfile = { enabled = false },
    rename = { enabled = false },
    statuscolumn = {
      enabled = true,
      left = { "mark", "sign" },
      right = { "fold", "git" },
      folds = {
        open = false,
        git_hl = true,
      },
      git = {
        patterns = { "GitSign" },
      },
    },
    terminal = { enabled = false },
    toggle = { enabled = false },
    win = { enabled = false },
    words = { enabled = false },
    styles = {},
  },
}
