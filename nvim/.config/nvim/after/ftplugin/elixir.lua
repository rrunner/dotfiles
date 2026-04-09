-- Elixir specific settings
vim.keymap.set("i", ">>", "|><space>", {
  noremap = true,
  buf = 0,
  silent = true,
  desc = "Replace >> with |> in elixir files (insert mode)",
})
