return {
  "echasnovski/mini-git",
  version = false,
  main = "mini.git",
  cond = vim.fn.executable("git") == 1,
  event = "BufEnter",
  config = function()
    require("mini.git").setup()

    vim.keymap.set(
      "n",
      "<leader>gc",
      [[<cmd>Git commit --verbose<cr>]],
      { noremap = true, silent = true, desc = "git commit verbose (mini-git)" }
    )

    vim.keymap.set(
      "n",
      "<leader>gi",
      [[<cmd>lua MiniGit.show_at_cursor()<cr>]],
      { noremap = true, silent = true, desc = "Show at cursor git information (mini-git)" }
    )
  end,
}
