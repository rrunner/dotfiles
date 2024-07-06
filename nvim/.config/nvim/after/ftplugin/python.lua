-- python specific settings
vim.opt_local.expandtab = true
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.foldmethod = "indent"
-- vim.opt_local.colorcolumn = "89"

-- python specific abbreviations
vim.cmd([[iabbrev <buffer> true True]])
vim.cmd([[iabbrev <buffer> false False]])

-- autoset compiler
vim.cmd([[compiler python]])
