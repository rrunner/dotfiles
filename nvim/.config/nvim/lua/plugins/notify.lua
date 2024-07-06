return {
  "rcarriga/nvim-notify",
  priority = 100,
  config = function()
    local notify = require("notify")

    -- use notify as nvim/plugin default notification system
    vim.notify = notify

    notify.setup({
      timeout = 3000,
      render = "wrapped-compact",
      max_width = 60,
    })
  end,
}
