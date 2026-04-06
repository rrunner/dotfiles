-- surround
vim.pack.add({ {
  src = "https://github.com/nvim-mini/mini.surround",
  version = "main",
} })

require("mini.surround").setup({
  highlight_duration = 700,
})
