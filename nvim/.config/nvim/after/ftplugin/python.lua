-- python specific settings
vim.bo.expandtab = true
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
-- vim.wo.foldmethod = "indent"
-- vim.wo.colorcolumn = "89"
-- avoid reindenting for certain keys in insert mode
-- vim.bo.indentkeys = ""

-- python specific abbreviations
vim.cmd([[iabbrev <buffer> true True]])
vim.cmd([[iabbrev <buffer> false False]])
