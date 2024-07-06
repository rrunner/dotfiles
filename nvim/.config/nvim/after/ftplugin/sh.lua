-- sh/bash specific settings
-- global formatoptions are not respected in sh/bash files
-- reset global options locally in sh/bash files
vim.opt_local.formatoptions:append({ "q", "j" })
vim.opt_local.formatoptions:remove({ "c", "r", "o" })
