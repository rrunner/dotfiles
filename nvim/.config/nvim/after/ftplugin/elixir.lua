-- Elixir specific settings
vim.keymap.set("i", ">>", "|><space>", {
  noremap = true,
  buffer = true,
  silent = true,
  desc = "Replace >> with |> in elixir files (insert mode)",
})
