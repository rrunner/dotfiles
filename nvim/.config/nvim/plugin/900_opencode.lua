-- opencode
if not vim.g.is_github_not_blocked then
  return
end

vim.pack.add({ {
  src = "https://github.com/nickjvandyke/opencode.nvim",
  version = vim.version.range("*"),
} })

vim.g.opencode_opts = {
  lsp = {
    -- use opencode for hover and code actions
    enabled = false,
  },
}
vim.o.autoread = true

vim.keymap.set({ "n", "x" }, "<leader>oa", function()
  require("opencode").ask("@this: ", { submit = true })
end, { desc = "Ask opencode" })

vim.keymap.set({ "n", "x" }, "<leader>os", function()
  require("opencode").select()
end, { desc = "Select opencode" })

vim.keymap.set("n", "<leader>oo", function()
  require("opencode").toggle()
end, { desc = "Toggle opencode" })
