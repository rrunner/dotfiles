return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {},
  init = function()
    vim.keymap.set(
      "n",
      "<localleader>ll",
      [[<cmd>lua require("persistence").load()<cr>]],
      { noremap = true, silent = true, desc = "Load/restore last session for the current directory" }
    )

    vim.keymap.set(
      "n",
      "<localleader>ls",
      [[<cmd>lua require("persistence").select()<cr>]],
      { noremap = true, silent = true, desc = "Select a session to load" }
    )
  end,
}
