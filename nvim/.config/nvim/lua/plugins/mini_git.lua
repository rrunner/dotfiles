return {
  "nvim-mini/mini-git",
  version = false,
  main = "mini.git",
  cond = vim.fn.executable("git") == 1,
  event = "BufEnter",
  config = function()
    local minigit = require("mini.git")
    minigit.setup()

    vim.keymap.set(
      "n",
      "<leader>gc",
      [[<cmd>Git commit --verbose<cr>]],
      { noremap = true, silent = true, desc = "git commit verbose (mini-git)" }
    )

    vim.keymap.set({ "n", "x" }, "<leader>gi", [[<cmd>lua MiniGit.show_at_cursor()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Show commit at hash in log, show buffer state at -/+ line in diff, or evolution of current line/selection in normal buffer (mini-git)",
    })

    vim.keymap.set(
      "n",
      "<leader>gh",
      [[<cmd>Git log<cr>]],
      { noremap = true, silent = true, desc = "git log (mini-git)" }
    )
  end,
}
