return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = false },
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
    words = { enabled = true },
    styles = {},
  },
}
