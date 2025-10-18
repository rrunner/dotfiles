-- git diffview
return {
  "sindrets/diffview.nvim",
  cond = vim.fn.executable("git") == 1,
  config = function()
    local actions = require("diffview.actions")
    local opts_diffview = {
      enhanced_diff_hl = true,
      default_args = {
        DiffviewOpen = { "--untracked-files=no", "--imply-local" },
        DiffviewFileHistory = { "--base=LOCAL" },
      },
      hooks = {
        diff_buf_read = function()
          vim.wo.number = true
          vim.wo.relativenumber = false
          vim.wo.signcolumn = "no"
          vim.wo.wrap = false
          vim.wo.winbar = "%=%m%r%{expand('%:p:h:t')}/%t"
        end,
        ---@diagnostic disable-next-line: unused-local
        diff_buf_win_enter = function(bufnr, winid, ctx)
          if ctx.layout_name:match("^diff2") then
            if ctx.symbol == "a" then
              vim.wo.winhl = "DiffAdd:DiffviewDiffAddAsDelete,DiffDelete:DiffviewDiffDelete,"
            elseif ctx.symbol == "b" then
              vim.wo.winhl = "DiffDelete:DiffviewDiffDelete,"
            end
          end
        end,
      },
      keymaps = {
        disable_defaults = true,
        file_panel = {
          { "n", "q", ":DiffviewClose<cr>", { silent = true, noremap = true, desc = "Close diffview" } },
          { "n", "<cr>", actions.select_entry, { desc = "Select entry" } },
          { "n", "<c-/>", actions.help("file_panel"), { desc = "Open the help panel" } },
        },
        file_history_panel = {
          { "n", "q", ":DiffviewClose<cr>", { silent = true, noremap = true, desc = "Close diffview" } },
          { "n", "<cr>", actions.select_entry, { desc = "Select entry" } },
          { "n", "<c-/>", actions.help("file_history_panel"), { desc = "Open the help panel" } },
        },
        help_panel = {
          { "n", "q", actions.close, { desc = "Close help menu" } },
          { "n", "<esc>", actions.close, { desc = "Close help menu" } },
        },
      },
    }
    require("diffview").setup(opts_diffview)
    -- vim.api.nvim_set_hl(0, "DiffviewDiffAdd", { bg = "#003300" })
    -- vim.api.nvim_set_hl(0, "DiffviewDiffText", { bg = "#666600", fg = "#FFFF00" })
  end,
  keys = {
    {
      "<leader>gd",
      [[<cmd>DiffviewOpen<cr>]],
      mode = "n",
      desc = "Open diffview without listing untracked files (git diff compared to index)",
      noremap = true,
      silent = true,
    },
  },
}
