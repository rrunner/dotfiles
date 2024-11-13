return {
  "echasnovski/mini-git",
  version = false,
  main = "mini.git",
  cond = vim.fn.executable("git") == 1,
  event = "BufEnter",
  config = function()
    require("mini.git").setup()

    local git_diff_location = function()
      local ft = vim.bo[0].filetype
      if ft ~= "diff" then
        vim.cmd([[Git diff]])
      else
        MiniGit.show_diff_source()
      end
    end

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

    vim.keymap.set(
      "n",
      "<leader>gh",
      [[<cmd>Git log<cr>]],
      { noremap = true, silent = true, desc = "git log or history... (mini-git)" }
    )

    vim.keymap.set("n", "<leader>gd", function()
      git_diff_location()
    end, { noremap = true, silent = true, desc = "git diff (or show file state in diff filetype) (mini-git)" })
  end,
}
