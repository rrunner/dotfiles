-- markdown specific settings

-- exclude for example hover windows (that renders markdown) from below settings
if vim.o.buftype ~= "" then
  return
end

vim.opt_local.textwidth = 81
vim.opt_local.wrapmargin = 0
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.colorcolumn = ""
vim.opt_local.commentstring = "<!--%s-->"
