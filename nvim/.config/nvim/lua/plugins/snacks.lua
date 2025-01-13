return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local snacks = require("snacks")
    local icons = require("config.icons")
    local opts = {
      bigfile = {
        enabled = true,
        notify = true,
      },
      notifier = {
        enabled = true,
        timeout = 3000,
        sort = { "added" }, --sort by time
        width = { min = 30, max = 0.5 },
        height = { min = 1, max = 0.5 },
        margin = { right = 0 },
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
      input = {
        enabled = true,
      },
      terminal = {
        enabled = true,
        win = {
          position = "float",
          height = 0.90,
          width = 0.90,
        },
      },
      indent = {
        enabled = true,
        indent = {
          enabled = false,
          char = "│",
          indent = {
            hl = "Comment",
          },
          only_scope = true,
          only_current = true,
        },
        animate = {
          enabled = false,
        },
        scope = {
          enabled = true,
          char = "┊",
          only_current = true,
        },
        chunk = {
          enabled = false,
        },
        -- filter for buffers to enable indent guides
        filter = function(buf)
          local exclude_ft = { "text", "markdown" }
          return vim.g.snacks_indent ~= false
            and vim.b[buf].snacks_indent ~= false
            and vim.bo[buf].buftype == ""
            and not vim.tbl_contains(exclude_ft, vim.bo[buf].filetype)
        end,
      },
      scope = {
        enabled = true,
        keys = {
          textobject = {
            ii = {
              cursor = true,
            },
            ai = {
              cursor = true,
            },
          },
        },
      },
      styles = {
        notification = {
          border = "rounded",
          wo = {
            winblend = 0,
            wrap = true,
          },
        },
        notification_history = {
          border = "rounded",
          width = 0.90,
          height = 0.90,
          keys = { q = "close" },
        },
        input = {
          row = math.floor(vim.opt.lines:get() / 2) - 1,
          columns = math.floor(vim.opt.columns:get() / 2),
        },
        terminal = {
          keys = {
            term_normal = {
              "<esc>",
              function()
                vim.cmd("stopinsert")
              end,
              mode = "t",
              expr = true,
              desc = "Switch to normal mode from terminal mode (in snacks terminals)",
            },
          },
        },
      },
    }

    snacks.setup(opts)

    vim.keymap.set("n", "<leader>z", function()
      snacks.zen()
    end, { desc = "Toggle zen mode", noremap = true, silent = true })

    vim.keymap.set({ "n", "t" }, "<c-;>", function()
      snacks.terminal.toggle()
    end, { desc = "Toggle terminal", noremap = true, silent = true })

    vim.keymap.set("n", "<leader>sm", function()
      snacks.notifier.show_history()
    end, {
      noremap = true,
      silent = true,
      desc = "Notification history",
    })
  end,
}
