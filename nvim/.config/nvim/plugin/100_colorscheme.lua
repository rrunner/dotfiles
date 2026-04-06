-- colorscheme
vim.pack.add({ "https://github.com/gbprod/nord.nvim" })

local colors = require("nord.colors")
require("nord").setup({
  borders = true,
  diff = { mode = "fg" },
})
vim.cmd.colorscheme("nord")
vim.api.nvim_set_hl(0, "WarningMsg", { bg = colors.default_bg, fg = colors.palette.aurora.yellow })
vim.api.nvim_set_hl(0, "ErrorMsg", { bg = colors.default_bg, fg = colors.palette.aurora.red })
