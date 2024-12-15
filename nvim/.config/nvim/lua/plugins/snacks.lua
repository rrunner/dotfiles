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
          statusline = false,
          tabline = false,
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

          -- reset DAP buffers on close
          if utils.is_debugger_running() then
            local exists_dapui, dapui = pcall(require, "dapui")
            if exists_dapui then
              dapui.open({ reset = true })
            end
          end
        end,
      },
      input = { enabled = true },
      terminal = {
        enabled = true,
        win = {
          position = "float",
          height = 0.95,
          width = 0.95,
        },
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
        },
        input = {
          row = 26,
        },
      },
    }
    require("snacks").setup(opts)
    vim.keymap.set("n", "<leader>z", function()
      Snacks.zen()
    end, { desc = "Toggle zen mode", noremap = true, silent = true })
    vim.keymap.set({ "n", "t" }, "<c-;>", function()
      Snacks.terminal.toggle()
    end, { desc = "Toggle terminal", noremap = true, silent = true })
  end,
}
