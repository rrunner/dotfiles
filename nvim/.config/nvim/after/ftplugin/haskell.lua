-- haskell specific settings
vim.opt_local.formatoptions:append({ "q", "j" })
vim.opt_local.formatoptions:remove({ "c", "r", "o" })

-- haskell specific abbreviations
vim.cmd([[iabbrev <buffer> true True]])
vim.cmd([[iabbrev <buffer> false False]])
