-- readline specific settings
-- global formatoptions are not respected in readline files
-- reset global options locally in readline files
vim.opt_local.formatoptions:append({ "q", "j" })
vim.opt_local.formatoptions:remove({ "c", "r", "o" })
