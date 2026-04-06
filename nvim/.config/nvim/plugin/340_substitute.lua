-- substitute
vim.pack.add({ "https://github.com/gbprod/substitute.nvim" })

require("substitute").setup({
  highlight_substituted_text = {
    enabled = true,
    timer = 700,
  },
})

vim.keymap.set("n", "cr", [[<cmd>lua require('substitute').operator()<cr>]], {
  noremap = true,
  silent = true,
  desc = "Substitute (change-replace) selection (normal mode)",
})

vim.keymap.set("n", "crr", [[<cmd>lua require('substitute').line()<cr>]], {
  noremap = true,
  silent = true,
  desc = "Substitute (change-replace) line",
})

vim.keymap.set("n", "crl", [[<cmd>lua require('substitute').eol()<cr>]], {
  noremap = true,
  silent = true,
  desc = "Substitute (change-replace) end of line from cursor location",
})

vim.keymap.set("x", "cr", [[<cmd>lua require('substitute').visual()<cr>]], {
  noremap = true,
  silent = true,
  desc = "Substitute (change-replace) selection (visual/select mode)",
})

vim.keymap.set("n", "cx", [[<cmd>lua require('substitute.exchange').operator()<cr>]], {
  noremap = true,
  silent = true,
  desc = "Exchange selections",
})

vim.keymap.set("n", "cxx", [[<cmd>lua require('substitute.exchange').line()<cr>]], {
  noremap = true,
  silent = true,
  desc = "Exchange line",
})
