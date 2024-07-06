return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {},
  init = function()
    vim.api.nvim_set_keymap(
      "n",
      "<localleader>ls",
      [[<cmd>lua require("persistence").load()<cr>]],
      { noremap = true, silent = true, desc = "Load/restore session for the current directory" }
    )
  end,
}
