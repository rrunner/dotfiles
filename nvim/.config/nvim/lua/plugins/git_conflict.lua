-- git conflict
return {
  "akinsho/git-conflict.nvim",
  version = "*",
  cond = vim.fn.executable("git") == 1,
  event = "BufEnter",
  config = function()
    require("git-conflict").setup()
    -- default key mappings
    -- co — choose ours (choose change from current branch)
    -- ct — choose theirs (choose change from incoming branch)
    -- cb — choose both (choose changes from both branches)
    -- c0 — choose none (do not choose any change)
    -- ]x — move to previous conflict
    -- [x — move to next conflict
  end,
}
