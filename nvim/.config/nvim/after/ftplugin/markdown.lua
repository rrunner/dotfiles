-- markdown specific settings

-- exclude for example hover windows (that renders markdown) from below settings
if vim.o.buftype ~= "" then
  return
end

vim.bo.textwidth = 81
vim.bo.wrapmargin = 0
vim.wo.wrap = true
vim.wo.linebreak = true
vim.wo.colorcolumn = ""
vim.bo.commentstring = "<!--%s-->"
