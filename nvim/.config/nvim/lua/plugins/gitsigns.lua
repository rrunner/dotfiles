-- gitsigns
return {
  "lewis6991/gitsigns.nvim",
  cond = vim.fn.executable("git") == 1,
  event = "BufEnter",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("gitsigns").setup({
      signcolumn = true,
      word_diff = false,
      diff_opts = {
        algorithm = "patience",
      },
      -- signs = {
      --   add = { text = "+" },
      --   change = { text = "~" },
      --   delete = { text = "_" },
      --   topdelete = { text = "‾" },
      --   changedelete = { text = "~" },
      -- },
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
  end,
}
