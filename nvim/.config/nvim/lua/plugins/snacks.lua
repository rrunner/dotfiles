-- exclude by file extension (files and grep pickers)
local exclude_fext = { "*.js", "*.js.map", "*.mjs", "*.jpg", "*.JPG", "*.avi", "*.AVI", "*.pdf", "*.PDF" }

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local snacks = require("snacks")
    local icons = require("config.icons")
    local utils = require("config.utils")
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
        icons = icons.snacks_notifier,
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
          backdrop = false,
        },
        shell = vim.o.shell,
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
      picker = {
        enabled = true,
        -- replace `vim.ui.select` with the snacks picker
        ui_select = true,
        formatters = {
          file = {
            filename_first = true,
          },
        },
        previewers = {
          git = {
            -- use native (terminal) or Neovim for previewing git diffs and commits
            native = false,
          },
        },
        jump = {
          -- reuse an existing window if the buffer is already open
          reuse_win = true,
        },
        win = {
          -- input window
          input = {
            keys = {
              ["<c-c>"] = false,
              ["<c-s>"] = false,
              ["<c-j>"] = false,
              ["<c-k>"] = false,
              ["<c-b>"] = false,
              ["<c-v>"] = { "edit_vsplit", mode = { "i" } },
              ["<c-x>"] = { "edit_split", mode = { "i" } },
              ["<c-n>"] = { "list_down", mode = { "i" } },
              ["<c-p>"] = { "list_up", mode = { "i" } },
              ["<c-/>"] = { "toggle_help", mode = { "i" } },
              ["<c-e>"] = { "close", mode = { "i" } },
              ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<c-f>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["v"] = "edit_vsplit",
              ["x"] = "edit_split",
              ["j"] = "list_down",
              ["k"] = "list_up",
              ["q"] = "close",
              ["?"] = "toggle_help",
            },
          },
          -- result list window
          list = {
            keys = {
              ["<c-c>"] = false,
              ["<c-s>"] = false,
              ["<c-j>"] = false,
              ["<c-k>"] = false,
              ["<c-b>"] = false,
            },
          },
          -- preview window
          preview = {
            keys = {
              ["<c-c>"] = false,
              ["<c-s>"] = false,
              ["<c-j>"] = false,
              ["<c-k>"] = false,
              ["<c-b>"] = false,
            },
            wo = {
              relativenumber = false,
            },
          },
        },
        icons = {
          files = {
            -- show file icons
            enabled = true,
          },
          ui = {
            selected = icons.selected,
            unselected = "  ",
          },
          diagnostics = {
            Error = icons.diagnosis.error,
            Warn = icons.diagnosis.warn,
            Info = icons.diagnosis.info,
            Hint = icons.diagnosis.hint,
          },
          kinds = icons._kinds_cmp,
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

    vim.keymap.set("n", "<leader>gg", function()
      snacks.picker.git_status()
    end, {
      noremap = true,
      silent = true,
      desc = "Git status",
    })

    vim.keymap.set("n", "<leader>sb", function()
      snacks.picker.buffers({
        layout = { preset = "select" },
        current = true,
        sort_lastused = true,
        -- delete buffer with dd in normal mode (default keymap set by picker)
      })
    end, {
      noremap = true,
      silent = true,
      desc = "Search/list all buffers (most recent priority)",
    })

    vim.keymap.set("n", "<c-tab>", function()
      snacks.picker.buffers({
        layout = { preset = "select" },
        current = false,
        sort_lastused = true,
        -- delete buffer with dd in normal mode (default keymap set by picker)
      })
    end, {
      noremap = true,
      silent = true,
      desc = "Search/list all buffers except the current buffer (most recent priority)",
    })

    vim.keymap.set("n", "<leader>sf", function()
      if utils.inside_git_repo() then
        snacks.picker.git_files({
          untracked = false,
          submodules = false,
        })
      else
        vim.ui.input({
          prompt = "Enter directory (cwd):",
          completion = "dir",
          default = vim.uv.cwd() .. utils.path_sep,
        }, function(input)
          if input == nil then
            -- window is closed with a keybind
            return
          elseif input and vim.fn.isdirectory(input) ~= 0 then
            snacks.picker.files({ hidden = true, follow = true, dirs = { input }, exclude = exclude_fext })
          else
            vim.notify("No valid directory")
          end
        end)
      end
    end, {
      noremap = true,
      silent = true,
      desc = "Search files",
    })

    vim.keymap.set("n", "<leader>sl", function()
      snacks.picker.lines()
    end, {
      noremap = true,
      silent = true,
      desc = "Search lines",
    })

    vim.keymap.set("n", "<leader>sd", function()
      snacks.picker.files({ hidden = true, cwd = vim.env.HOME .. "/.config/nvim", follow = true })
    end, {
      noremap = true,
      silent = true,
      desc = "Search dotfiles (neovim config)",
    })

    vim.keymap.set("n", "<leader>so", function()
      snacks.picker.recent()
    end, {
      noremap = true,
      silent = true,
      desc = "Search recently opened files",
    })

    vim.keymap.set("n", "<leader>sh", function()
      snacks.picker.help()
    end, {
      noremap = true,
      silent = true,
      desc = "Search help (help tags)",
    })

    vim.keymap.set("n", "<leader>sq", function()
      snacks.picker.qflist()
    end, {
      noremap = true,
      silent = true,
      desc = "Search quickfix",
    })

    vim.keymap.set("n", "<leader>sn", function()
      local notes_folder
      notes_folder = vim.fn.stdpath("config") .. utils.path_sep .. "templates"
      if vim.fn.isdirectory(notes_folder) == 0 then
        vim.notify("Notes folder is not configured. See snacks.lua file", vim.log.levels.WARN)
        return nil
      end
      snacks.picker.files({ cwd = notes_folder })
    end, {
      noremap = true,
      silent = true,
      desc = "Search notes",
    })

    vim.keymap.set("n", "<leader>ss", function()
      snacks.picker.lsp_symbols()
    end, {
      noremap = true,
      silent = true,
      desc = "Search LSP document symbols",
    })

    vim.keymap.set("n", "<leader>sg", function()
      vim.ui.input({
        prompt = "Enter directory (cwd):",
        completion = "dir",
        default = vim.uv.cwd() .. utils.path_sep,
      }, function(input)
        if input == nil then
          -- window is closed with a keybind
          return
        elseif input and vim.fn.isdirectory(input) ~= 0 then
          snacks.picker.grep({
            dirs = { input },
            hidden = true,
            follow = true,
            ignored = true,
            exclude = exclude_fext,
          })
        else
          vim.notify("No valid directory")
        end
      end)
    end, {
      noremap = true,
      silent = true,
      desc = "Search (live) text from dir (user input optional)",
    })

    vim.keymap.set("n", "<leader>sk", function()
      snacks.picker.keymaps()
    end, {
      noremap = true,
      silent = true,
      desc = "Search keymaps",
    })

    vim.keymap.set({ "n", "x" }, "<leader>sc", function()
      snacks.picker.grep_word({
        dirs = { vim.uv.cwd() },
        hidden = true,
        follow = true,
        ignored = true,
        exclude = exclude_fext,
      })
    end, {
      noremap = true,
      silent = true,
      desc = "Search visual selection or word in current working directory",
    })

    vim.keymap.set("n", "<leader>sr", function()
      snacks.picker.resume()
    end, {
      noremap = true,
      silent = true,
      desc = "Search resume",
    })

    vim.keymap.set({ "n", "x" }, "<leader>st", function()
      snacks.picker.grep_word({ buf = true, dirs = { vim.fn.expand("%:p") } })
    end, {
      noremap = true,
      silent = true,
      desc = "Search visual selection or word in current buffer only",
    })

    vim.keymap.set({ "n", "x" }, "<leader>s/", function()
      snacks.picker.grep_word({ buffers = true })
    end, {
      noremap = true,
      silent = true,
      desc = "Search visual selection or word in all open buffers",
    })

    vim.keymap.set("n", "z=", function()
      if vim.opt_local.spell:get() then
        snacks.picker.spelling({
          layout = { preset = "select" },
        })
      end
    end, {
      noremap = true,
      silent = true,
      desc = "Spell suggestions (if spellcheck is active)",
    })

    vim.keymap.set("n", "<leader>sS", function()
      snacks.picker.lsp_workspace_symbols()
    end, {
      noremap = true,
      silent = true,
      desc = "Search LSP workspace symbols",
    })
  end,
}
