return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local icons = require("config.icons")
    local opts = {
      bigfile = {
        enabled = true,
        notify = true,
        -- size = 1.5 * 1024 * 1024,
      },
      notifier = {
        enabled = true,
        timeout = 3000,
        width = { min = 30, max = 30 },
        height = { min = 5, max = 0.3 },
        margin = { top = 0, right = 0, bottom = 0 },
        icons = icons.snacks,
        style = "fancy",
      },
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" },
        right = { "fold", "git" },
        folds = {
          open = false,
          git_hl = true,
        },
        git = {
          patterns = { "GitSign" },
        },
        refresh = 20,
      },
      zen = {
        enabled = true,
        toggles = {
          dim = false,
          git_signs = true,
          diagnostics = true,
          inlay_hints = false,
        },
        show = {
          statusline = true,
        },
        on_open = function(win)
          -- increase window width for DAP repl buffers
          local ftypes = { "dap-repl" }
          if vim.tbl_contains(ftypes, vim.bo.filetype) then
            vim.api.nvim_win_set_width(win, 150)
          end
        end,
        on_close = function()
          local utils = require("config.utils")

          if utils.is_debugger_running() then
            local exists_dapui, dapui = pcall(require, "dapui")
            if exists_dapui then
              dapui.open({ reset = true })
            end
          end
        end,
      },
      styles = {
        notification = {
          wo = {
            winblend = 0,
            wrap = true,
          },
          history = {
            width = 0.9,
            height = 0.9,
            keys = { q = "close" },
          },
          zen = {
            backdrop = 1,
            width = 0.75,
            height = 1,
          },
        },
      },
    }
    require("snacks").setup(opts)
    vim.keymap.set("n", "<leader>z", function()
      Snacks.zen()
    end, { noremap = true, silent = true })
  end,
}
