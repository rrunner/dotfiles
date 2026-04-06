-- git
vim.pack.add({
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/nvim-mini/mini-git", version = "main" },
  { src = "https://github.com/akinsho/git-conflict.nvim" },
})

-- gitsigns
require("gitsigns").setup({
  signcolumn = true,
  word_diff = false,
  diff_opts = {
    algorithm = "patience",
  },
  on_attach = function(bufnr)
    local gs = require("gitsigns")

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- navigation between git hunks
    map("n", "]g", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gs.nav_hunk("next")
      end
    end, { desc = "Next git hunk (or diff change)" })

    map("n", "[g", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gs.nav_hunk("prev")
      end
    end, { desc = "Previous git hunk (or diff change)" })

    -- actions
    map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk (undo if staged)" })
    map("v", "<leader>gs", function()
      gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Stage hunk (undo if staged)" })
    map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
    map("v", "<leader>gr", function()
      gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, { desc = "Reset hunk" })
    map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
    map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
    map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
  end,
})

-- mini-git
require("mini.git").setup()

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

vim.keymap.set(
  "n",
  "<leader>gB",
  [[<cmd>vertical Git blame -- %<cr>]],
  { noremap = true, silent = true, desc = "Show latest commits per line in vertical split" }
)

-- git-conflict
require("git-conflict").setup({})
-- default key mappings:
-- co — choose ours (choose change from current branch)
-- ct — choose theirs (choose change from incoming branch)
-- cb — choose both (choose changes from both branches)
-- c0 — choose none (do not choose any change)
-- ]x — move to previous conflict
-- [x — move to next conflict
