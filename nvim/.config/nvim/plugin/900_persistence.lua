-- persistence
vim.pack.add({ "https://github.com/folke/persistence.nvim" })

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

require("persistence").setup({})
