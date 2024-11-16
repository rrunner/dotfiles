return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local icons = require("config.icons")
    local opts = {
      bigfile = {
        enabled = true,
        notify = true,
        -- size = 1.5 * 1024 * 1024,
      },
      notifier = {
        enabled = true,
        timeout = 3000,
        width = { min = 30, max = 30 },
        height = { min = 5, max = 0.3 },
        margin = { top = 0, right = 0, bottom = 0 },
        icons = icons.snacks,
        style = "fancy",
      },
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
      styles = {
        notification = {
          wo = {
            winblend = 0,
            wrap = true,
          },
          history = {
            width = 0.9,
            height = 0.9,
            keys = { q = "close" },
          },
        },
      },
    }
    require("snacks").setup(opts)
  end,
}
