-- zen mode
return {
  "folke/zen-mode.nvim",
  keys = {
    { "<leader>z", [[<cmd>ZenMode<cr>]], mode = "n", desc = "Open window in Zen mode", noremap = true, silent = true },
  },
  config = function()
    local utils = require("config.utils")

    local opts = {
      window = {
        backdrop = 1,
        width = 0.7,
        height = 1,
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
        },
        twilight = { enabled = false },
        gitsigns = { enabled = true },
        tmux = { enabled = false },
        alacritty = {
          enabled = true,
          font = "11",
        },
      },
      -- callback when the Zen window opens
      on_open = function(win)
        -- increase window width for DAP repl buffers
        local ftypes = { "dap-repl" }
        if vim.tbl_contains(ftypes, vim.bo.filetype) then
          vim.api.nvim_win_set_width(win, 150)
        end
      end,

      -- callback when the Zen window closes
      on_close = function()
        if utils.is_debugger_running() then
          local exists_dapui, dapui = pcall(require, "dapui")
          if exists_dapui then
            dapui.open({ reset = true })
          end
        end
      end,
    }

    require("zen-mode").setup(opts)
  end,
}
