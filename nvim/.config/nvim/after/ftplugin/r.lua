-- R specific settings
vim.opt_local.expandtab = true
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
-- vim.opt_local.colorcolumn = "81"

-- insert mode mappings
vim.api.nvim_set_keymap("i", "<>", "<- ", {
  silent = true,
  desc = "Replace <> with <- in R files (insert mode)",
})

vim.api.nvim_set_keymap("i", ">>", "%>%<space>", {
  silent = true,
  desc = "Replace >> with %>% in R files (insert mode)",
})

-- R specific abbreviations
vim.cmd([[iabbrev <buffer> true TRUE]])
vim.cmd([[iabbrev <buffer> false FALSE]])

-- autoset compiler
vim.cmd([[compiler r]])
