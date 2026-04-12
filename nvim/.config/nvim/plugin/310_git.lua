-- git
vim.pack.add({
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/nvim-mini/mini-git", version = "main" },
  { src = "https://github.com/spacedentist/resolve.nvim" },
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
      opts.buf = bufnr
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

-- resolve.nvim (git conflicts)
require("resolve").setup({
  default_keymaps = false,
  on_conflict_detected = function(args)
    vim.diagnostic.enable(false, { bufnr = args.bufnr })
  end,
  on_conflicts_resolved = function(args)
    vim.diagnostic.enable(true, { bufnr = args.bufnr })
  end,
})

-- use the commands to avoid adding keymaps:
-- :ResolveNext - Navigate to next conflict
-- :ResolvePrev - Navigate to previous conflict
-- :ResolveOurs - Choose ours version
-- :ResolveTheirs - Choose theirs version
-- :ResolveBoth - Choose both versions (ours then theirs)
-- :ResolveBothReverse - Choose both versions (theirs then ours)
-- :ResolveBase - Choose base/ancestor version (diff3 only)
-- :ResolveNone - Choose neither version
-- :ResolveList - List all conflicts in quickfix
-- :ResolveDetect - Manually detect conflicts
-- :ResolveDiffOurs - Show diff of our changes from base (diff3 only)
-- :ResolveDiffTheirs - Show diff of their changes from base (diff3 only)
-- :ResolveDiffBoth - Show both diffs in floating window (diff3 only)
-- :ResolveDiffOursTheirs - Show diff ours → theirs (works without diff3)
-- :ResolveDiffTheirsOurs - Show diff theirs → ours (works without diff3)
