return {
  "nvim-mini/mini-git",
  version = false,
  main = "mini.git",
  cond = vim.fn.executable("git") == 1,
  event = "BufEnter",
  config = function()
    local minigit = require("mini.git")
    minigit.setup()

    local git_log_cmd = [[Git log --pretty=format:\%h\ \%ad\ \%an\ |\ \%s --topo-order --date=iso]]
    local git_log_file_cmd = git_log_cmd .. " --follow -- %"

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
      "<cmd>" .. git_log_cmd .. "<cr>",
      { noremap = true, silent = true, desc = "git log (mini-git)" }
    )

    vim.keymap.set(
      "n",
      "<leader>gH",
      "<cmd>" .. git_log_file_cmd .. "<cr>",
      { noremap = true, silent = true, desc = "git log file (mini-git)" }
    )
  end,
}
