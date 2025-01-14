-- nvim/tmux integration
return {
  enabled = false,
  "aserowy/tmux.nvim",
  opts = {
    copy_sync = {
      sync_clipboard = true,
    },
  },
}
