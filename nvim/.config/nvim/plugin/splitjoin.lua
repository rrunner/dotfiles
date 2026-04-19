-- splitjoin
vim.keymap.set("n", "gJ", [[<cmd>TSJJoin<cr>]], { noremap = true, silent = true, desc = "Join blocks of code" })
vim.keymap.set("n", "gS", [[<cmd>TSJSplit<cr>]], { noremap = true, silent = true, desc = "Split blocks of code" })

require("treesj").setup({
  use_default_keymaps = false,
  max_join_length = 100,
  dot_repeat = true,
  -- default configuration for languages
  langs = {},
})
