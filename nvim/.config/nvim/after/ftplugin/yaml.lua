-- yaml specific settings
-- global formatoptions are not respected in yaml files
-- reset global options locally in yaml files
vim.opt_local.formatoptions:append({ "q", "j" })
vim.opt_local.formatoptions:remove({ "c", "r", "o" })
