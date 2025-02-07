-- grep picker: global rg options (see .config/ripgrep/ripgreprc)
-- files picker: fd global ignore file (see .config/fd/ignore)

-- exclude by file extension (can be used by files and grep pickers)
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
      explorer = {
        enabled = true,
        replace_netrw = true,
      },
      picker = {
        enabled = true,
        -- replace `vim.ui.select` with the snacks picker
        ui_select = true,
        layout = {
          cycle = true,
        },
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
              ["<c-h>"] = false,
              ["<c-l>"] = false,
              ["<c-f>"] = false,
              ["<c-v>"] = { { "pick_win", "edit_vsplit" }, mode = { "i" } },
              ["<c-x>"] = { { "pick_win", "edit_split" }, mode = { "i" } },
              ["<c-n>"] = { "list_down", mode = { "i" } },
              ["<c-p>"] = { "list_up", mode = { "i" } },
              ["<c-/>"] = { "toggle_help", mode = { "i" } },
              ["<c-e>"] = { "close", mode = { "i", "n" } },
              ["<a-h>"] = { "preview_scroll_left", mode = { "i", "n" } },
              ["<a-l>"] = { "preview_scroll_right", mode = { "i", "n" } },
              ["<a-n>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<a-p>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<a-j>"] = false,
              ["<a-k>"] = false,
              ["v"] = { { "pick_win", "edit_vsplit" }, mode = "n" },
              ["x"] = { { "pick_win", "edit_split" }, mode = "n" },
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
              ["<c-h>"] = false,
              ["<c-l>"] = false,
              ["<c-f>"] = false,
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
              ["<c-h>"] = false,
              ["<c-l>"] = false,
              ["<c-f>"] = false,
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
          git = {
            enabled = true,
            commit = icons.git_icons.commit .. " ",
            staged = icons.git_icons.staged,
            added = icons.git_icons.added,
            deleted = icons.git_icons.deleted,
            ignored = icons.git_icons.ignored,
            modified = icons.git_icons.modified,
            renamed = icons.git_icons.renamed,
            unmerged = icons.git_icons.unmerged,
            untracked = icons.git_icons.untracked,
          },
          kinds = icons._kinds_cmp,
        },
        sources = {
          explorer = {
            follow_file = true,
            auto_close = false,
            watch = true,
            git_status = true,
            git_status_open = true,
            git_untracked = true,
            diagnostics = true,
            diagnostics_open = true,
            layout = {
              preset = "sidebar",
              layout = { position = "right" },
            },
            on_show = function()
              vim.cmd("wincmd =")

              -- reset debugger windows if DAP is running
              if utils.is_debugger_running() then
                local exists_dapui, dapui = pcall(require, "dapui")
                if exists_dapui and utils.is_debugger_running() then
                  dapui.open({ reset = true })
                end
              end
            end,
            on_close = function()
              vim.cmd("wincmd =")

              -- reset debugger windows if DAP is running
              if utils.is_debugger_running() then
                local exists_dapui, dapui = pcall(require, "dapui")
                if exists_dapui and utils.is_debugger_running() then
                  dapui.open({ reset = true })
                end
              end
            end,
            win = {
              list = {
                keys = {
                  ["<bs>"] = "explorer_up",
                  ["h"] = false,
                  ["l"] = false,
                  ["a"] = "explorer_add",
                  ["d"] = "explorer_del",
                  ["r"] = "explorer_rename",
                  ["c"] = false,
                  ["m"] = false,
                  ["o"] = "confirm",
                  ["y"] = "explorer_copy",
                  ["u"] = false,
                  ["]g"] = "explorer_git_next",
                  ["[g"] = "explorer_git_prev",
                  ["<c-c>"] = false,
                  ["."] = "explorer_focus",
                  ["P"] = false,
                  ["I"] = "toggle_ignored",
                  ["H"] = "toggle_hidden",
                  ["Z"] = false,
                  ["x"] = { { "pick_win", "edit_split" }, mode = "n" },
                  ["v"] = { { "pick_win", "edit_vsplit" }, mode = "n" },
                  ["]d"] = "explorer_diagnostic_next",
                  ["[d"] = "explorer_diagnostic_prev",
                  ["]w"] = false,
                  ["[w"] = false,
                  ["]e"] = false,
                  ["[e"] = false,
                },
              },
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

    local layout1 = {
      layout = {
        box = "horizontal",
        width = 0.9,
        min_width = 120,
        height = 0.9,
        {
          box = "vertical",
          border = "rounded",
          title = "{title} {live} {flags}",
          { win = "input", height = 1, border = "bottom" },
          { win = "list", border = "none", width = 0.35 },
        },
        { win = "preview", title = "{preview}", border = "rounded", width = 0.65 },
      },
    }

    local layout2 = {
      layout = {
        width = 0.9,
        height = 0.9,
      },
    }

    vim.keymap.set("n", "<leader>z", function()
      snacks.zen()
    end, { desc = "Toggle zen mode", noremap = true, silent = true })

    vim.keymap.set({ "n", "t" }, "<c-;>", function()
      snacks.terminal.toggle()
    end, { desc = "Toggle terminal", noremap = true, silent = true })

    vim.keymap.set("n", "<leader>gg", function()
      snacks.picker.git_status({ layout = layout1 })
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
          layout = layout2,
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
            snacks.picker.files({
              dirs = { input },
              hidden = true,
              follow = true,
              exclude = exclude_fext,
              layout = layout2,
            })
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
      snacks.picker.files({ hidden = true, cwd = vim.env.HOME .. "/.config/nvim", follow = true, layout = layout2 })
    end, {
      noremap = true,
      silent = true,
      desc = "Search dotfiles (neovim config)",
    })

    vim.keymap.set("n", "<leader>so", function()
      snacks.picker.recent({ layout = layout2 })
    end, {
      noremap = true,
      silent = true,
      desc = "Search recently opened files",
    })

    vim.keymap.set("n", "<leader>sh", function()
      snacks.picker.help({ layout = layout2 })
    end, {
      noremap = true,
      silent = true,
      desc = "Search help (help tags)",
    })

    vim.keymap.set("n", "<leader>sq", function()
      snacks.picker.qflist({ layout = layout2 })
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
      snacks.picker.files({ cwd = notes_folder, layout = layout2 })
    end, {
      noremap = true,
      silent = true,
      desc = "Search notes",
    })

    vim.keymap.set("n", "<leader>ss", function()
      snacks.picker.lsp_symbols({
        focus = "list",
        layout = { preset = "vscode", preview = "main" },
      })
    end, {
      noremap = true,
      silent = true,
      desc = "Search LSP document symbols",
    })

    vim.keymap.set("n", "<leader>sS", function()
      snacks.picker.lsp_workspace_symbols({ layout = layout2 })
    end, {
      noremap = true,
      silent = true,
      desc = "Search LSP workspace symbols",
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
            layout = layout2,
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
      snacks.picker.keymaps({ layout = layout2 })
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
        layout = layout2,
      })
    end, {
      noremap = true,
      silent = true,
      desc = "Search visual selection or word in current working directory",
    })

    vim.keymap.set("n", "<leader>sr", function()
      snacks.picker.resume({ layout = layout2 })
    end, {
      noremap = true,
      silent = true,
      desc = "Search resume",
    })

    vim.keymap.set({ "n", "x" }, "<leader>st", function()
      snacks.picker.grep_word({
        buf = true,
        dirs = { vim.fn.expand("%:p") },
        layout = layout2,
      })
    end, {
      noremap = true,
      silent = true,
      desc = "Search visual selection or word in current buffer only",
    })

    vim.keymap.set({ "n", "x" }, "<leader>s/", function()
      snacks.picker.grep_word({ buffers = true, layout = layout2 })
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

    vim.keymap.set("n", "<leader>sm", function()
      snacks.picker.notifications({ layout = layout2 })
    end, {
      noremap = true,
      silent = true,
      desc = "Search notification history",
    })

    vim.keymap.set("n", "<leader>ex", function()
      snacks.picker.explorer()
    end, {
      noremap = true,
      silent = true,
      desc = "Toggle file explorer",
    })

    vim.keymap.set("n", "<leader>sp", function()
      snacks.picker.projects({
        dev = { "~/dev", "~/projects" },
        patterns = {
          ".git",
          "pyproject.toml",
          "requirements.txt",
          "pyrightconfig.json",
          "Pipfile",
          ".venv",
          "venv",
        },
        recent = false,
        win = {
          input = {
            keys = {
              ["<c-e>"] = { "close", mode = { "i", "n" } },
              ["<cr>"] = { { "tcd", "picker_explorer" }, mode = { "n", "i" } },
              ["<c-f>"] = false,
              ["<c-g>"] = false,
              ["<c-r>"] = false,
              ["<c-w>"] = false,
              ["<c-t>"] = false,
            },
          },
        },
      })
    end, {
      noremap = true,
      silent = true,
      desc = "Search projects",
    })
  end,
}
