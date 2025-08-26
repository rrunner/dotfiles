-- grep picker: global rg options (see .config/ripgrep/ripgreprc)
-- files picker: fd global ignore file (see .config/fd/ignore)

-- exclude by file extension (can be used by files and grep pickers)
local exclude_fext = { "*.js", "*.js.map", "*.mjs", "*.jpg", "*.JPG", "*.avi", "*.AVI", "*.pdf", "*.PDF", "*.h", "*.c" }

-- picker layouts
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

local layout3 = {
  preset = "select",
  layout = {
    width = 0.3,
    height = 0.2,
  },
}

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
        win = {
          backdrop = { transparent = false },
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
      scratch = {
        name = "Scratch",
        win = { style = "scratch" },
        win_by_ft = {
          lua = {
            keys = {
              ["source"] = {
                "<c-cr>",
                function(self)
                  local name = "scratch." .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ":e")
                  Snacks.debug.run({ buf = self.buf, name = name })
                end,
                desc = "Source buffer",
                mode = { "n", "x" },
              },
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
              -- disabled
              ["<c-s>"] = false,
              ["<c-j>"] = false,
              ["<c-h>"] = false,
              ["<c-l>"] = false,
              ["<a-j>"] = false,
              ["<a-k>"] = false,
              -- dual mode
              ["<c-c>"] = { "close", mode = { "i", "n" } },
              -- insert mode
              ["<c-k>"] = { "<esc>lDa", mode = "i", expr = true, desc = "delete from cursor to the right" },
              ["<c-u>"] = { "<esc>d^xi", mode = "i", expr = true, desc = "delete from cursor to the left" },
              ["<c-v>"] = { { "pick_win", "edit_vsplit" }, mode = "i" },
              ["<c-x>"] = { { "pick_win", "edit_split" }, mode = "i" },
              ["<c-n>"] = { "list_down", mode = "i" },
              ["<c-p>"] = { "list_up", mode = "i" },
              ["<a-h>"] = { "preview_scroll_left", mode = "i" },
              ["<a-l>"] = { "preview_scroll_right", mode = "i" },
              ["<a-n>"] = { "preview_scroll_down", mode = "i" },
              ["<a-p>"] = { "preview_scroll_up", mode = "i" },
              ["<c-/>"] = { "toggle_help", mode = "i" },
              ["<c-a>"] = { "<home>", mode = "i", expr = true, desc = "start of line" },
              ["<c-e>"] = { "<end>", mode = "i", expr = true, desc = "end of line" },
              ["<c-f>"] = { "<right>", mode = "i", expr = true, desc = "move cursor to the right" },
              ["<c-b>"] = { "<left>", mode = "i", expr = true, desc = "move cursor to the left" },
              ["<c-w>"] = { "<c-s-w>", mode = "i", expr = true, desc = "delete word" },
              -- normal mode
              ["v"] = { { "pick_win", "edit_vsplit" }, mode = "n" },
              ["x"] = { { "pick_win", "edit_split" }, mode = "n" },
              ["j"] = { "list_down", mode = "n" },
              ["k"] = { "list_up", mode = "n" },
              ["q"] = { "close", mode = "n" },
              ["?"] = { "toggle_help", mode = "n" },
            },
          },
          -- result list window
          list = {
            keys = {
              ["<c-a>"] = false,
              ["<c-c>"] = false,
              ["<c-s>"] = false,
              ["<c-j>"] = false,
              ["<c-k>"] = false,
              ["<c-u>"] = false,
              ["<c-b>"] = false,
              ["<c-h>"] = false,
              ["<c-l>"] = false,
              ["<c-f>"] = false,
            },
          },
          -- preview window
          preview = {
            keys = {
              ["<c-a>"] = false,
              ["<c-c>"] = false,
              ["<c-s>"] = false,
              ["<c-j>"] = false,
              ["<c-k>"] = false,
              ["<c-u>"] = false,
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
          files = {
            hidden = true,
            follow = true,
            layout = layout2,
          },
          git_files = {
            untracked = false,
            submodules = false,
            layout = layout2,
          },
          grep = {
            hidden = true,
            follow = true,
            ignored = true,
            layout = layout2,
          },
          grep_word = {
            hidden = true,
            follow = true,
            ignored = true,
            layout = layout2,
          },
          buffers = {
            sort_lastused = true,
            layout = layout3,
          },
          git_status = {
            ignored = false,
            layout = layout1,
          },
          git_branches = {
            --show all branches (incl. remote)
            all = true,
            win = {
              input = {
                keys = {
                  ["<c-a>"] = { "git_branch_add", mode = { "n", "i" } },
                  ["<c-d>"] = { "git_branch_del", mode = { "n", "i" } },
                  ["<c-x>"] = false,
                },
              },
            },
          },
          recent = {
            layout = layout2,
          },
          help = {
            layout = layout2,
          },
          qflist = {
            layout = layout2,
          },
          lsp_symbols = {
            focus = "input",
            layout = { cycle = true, preset = "vscode", preview = "main" },
          },
          treesitter = {
            focus = "input",
            layout = { cycle = false, preset = "vscode", preview = "main" },
            filter = {
              -- json = true,
              -- jsonc = true,
            },
          },
          lsp_workspace_symbols = {
            layout = layout2,
          },
          keymaps = {
            layout = layout2,
          },
          resume = {
            layout = layout2,
          },
          spelling = {
            layout = {
              preset = "select",
              layout = { height = 0.53 },
            },
            win = {
              list = {
                wo = { number = true },
              },
            },
          },
          notifications = {
            layout = layout2,
            win = {
              preview = {
                wo = { statuscolumn = "", signcolumn = "no" },
              },
            },
          },
          projects = {
            dev = { "~/dev", "~/projects" },
            patterns = {
              ".git",
              "pyproject.toml",
              "uv.lock",
              "requirements.txt",
              "Pipfile",
              ".venv",
              "venv",
            },
            recent = false,
            win = {
              input = {
                keys = {
                  ["<c-e>"] = false,
                  ["<cr>"] = { { "tcd", "picker_explorer" }, mode = { "n", "i" } },
                  ["<c-f>"] = false,
                  ["<c-g>"] = false,
                  ["<c-r>"] = false,
                  ["<c-w>"] = false,
                  ["<c-t>"] = false,
                },
              },
            },
          },
          explorer = {
            hidden = false,
            follow_file = true,
            auto_close = false,
            watch = true,
            git_status = true,
            git_status_open = true,
            git_untracked = true, -- display untracked icon
            diagnostics = true,
            diagnostics_open = true,
            include = {}, -- always include
            exclude = { ".mypy_cache", "__pycache__" },
            layout = {
              preset = "sidebar",
              hidden = { "input" },
              auto_hide = { "input" },
              layout = { position = "right" },
            },
            icons = {
              tree = {
                vertical = "  ",
                middle = "  ",
                last = "  ",
              },
            },
            on_show = function()
              if utils.is_debugger_running() then
                vim.schedule(function()
                  -- TODO: console window is not reset properly
                  require("dapui").open({ reset = true })
                end)
              else
                vim.cmd("horizontal wincmd =")
              end
            end,
            on_close = function()
              if utils.is_debugger_running() then
                vim.schedule(function()
                  -- TODO: console window is not reset properly
                  require("dapui").open({ reset = true })
                end)
              else
                vim.cmd("horizontal wincmd =")
              end
            end,
            win = {
              list = {
                keys = {
                  ["<bs>"] = "explorer_up",
                  ["h"] = "explorer_close",
                  ["l"] = "confirm",
                  ["a"] = "explorer_add",
                  ["d"] = "explorer_del",
                  ["r"] = "explorer_rename",
                  ["c"] = false,
                  ["m"] = "explorer_move",
                  ["o"] = "confirm",
                  ["y"] = { "explorer_yank", mode = { "n", "x" } },
                  ["p"] = "explorer_paste",
                  ["u"] = false,
                  ["]g"] = "explorer_git_next",
                  ["[g"] = "explorer_git_prev",
                  ["<c-c>"] = "close",
                  ["<leader>/"] = "picker_grep", -- grep in folder
                  ["<c-t>"] = "terminal", -- start terminal in folder
                  ["."] = "explorer_focus",
                  ["P"] = false,
                  ["I"] = "toggle_ignored",
                  ["H"] = "toggle_hidden",
                  ["Z"] = "explorer_close_all",
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
          keys = {
            ["<c-a>"] = { "<home>", mode = "i", expr = true, desc = "start of line (input)" },
            ["<c-e>"] = { "<end>", mode = "i", expr = true, desc = "end of line (input)" },
            ["<c-f>"] = { "<right>", mode = "i", expr = true, desc = "move cursor to the right (input)" },
            ["<c-k>"] = { "<esc>lDa", mode = "i", expr = true, desc = "delete from cursor to the right (input)" },
          },
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
        scratch = {
          width = 0.6,
          height = 0.6,
          border = "rounded",
          wo = {
            number = true,
            relativenumber = false,
            wrap = false,
          },
          keys = {
            q = false,
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

    vim.keymap.set("n", "<leader>gg", function()
      snacks.picker.git_status()
    end, {
      noremap = true,
      silent = true,
      desc = "Git status",
    })

    vim.keymap.set("n", "<leader>sb", function()
      snacks.picker.buffers({
        current = true,
      })
    end, {
      noremap = true,
      silent = true,
      desc = "Search/list all buffers (most recent priority)",
    })

    vim.keymap.set("n", "<c-tab>", function()
      snacks.picker.buffers({
        current = false,
      })
    end, {
      noremap = true,
      silent = true,
      desc = "Search/list all buffers except the current buffer (most recent priority)",
    })

    vim.keymap.set("n", "<leader>sf", function()
      if utils.inside_git_repo() then
        snacks.picker.git_files()
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
              exclude = exclude_fext,
            })
          else
            vim.notify("No valid directory")
          end
        end)
      end
    end, {
      noremap = true,
      silent = true,
      desc = "Search files (tracked git files inside git repo)",
    })

    vim.keymap.set("n", "<leader>sl", function()
      snacks.picker.lines()
    end, {
      noremap = true,
      silent = true,
      desc = "Search lines",
    })

    vim.keymap.set("n", "<leader>sd", function()
      snacks.picker.files({ cwd = vim.env.HOME .. "/.config/nvim" })
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
      snacks.picker({
        finder = "files",
        format = "file",
        show_empty = true,
        hidden = false,
        ignored = false,
        follow = false,
        supports_live = false,
        cmd = "rg",
        dirs = { vim.fn.stdpath("config") .. utils.path_sep .. "templates" },
        title = "Select template notes",
        layout = {
          preset = "select",
        },
        actions = {
          confirm = function(picker, item)
            local ct = os.date("*t")
            local year, month, day = ct.year, ct.month, ct.day
            local ts = string.format("_%4d-%02d-%02d", year, month, day)
            picker:close()
            vim.schedule(function()
              vim.cmd("silent 0read" .. item.file)
              local file = vim.fn.fnamemodify(item.file, ":t:r")
              local ext = vim.fn.fnamemodify(item.file, ":e")
              vim.cmd.saveas(file .. ts .. "." .. ext)
            end)
          end,
        },
      })
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

    vim.keymap.set("n", "<leader>sS", function()
      snacks.picker.lsp_workspace_symbols()
    end, {
      noremap = true,
      silent = true,
      desc = "Search LSP workspace symbols",
    })

    vim.keymap.set("n", "<leader>sk", function()
      snacks.picker.keymaps()
    end, {
      noremap = true,
      silent = true,
      desc = "Search keymaps",
    })

    vim.keymap.set("n", "<leader>sr", function()
      snacks.picker.resume()
    end, {
      noremap = true,
      silent = true,
      desc = "Search resume",
    })

    -- vim.keymap.set({ "n", "x" }, "g/", function()
    --   snacks.picker.grep_word({
    --     buf = true,
    --     dirs = { vim.fn.expand("%:p") },
    --   })
    -- end, {
    --   noremap = true,
    --   silent = true,
    --   desc = "Search visual selection or word in current buffer only (grep word in buffer)",
    -- })

    vim.keymap.set("n", "<leader>/", function()
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
            exclude = exclude_fext,
          })
        else
          vim.notify("No valid directory")
        end
      end)
    end, {
      noremap = true,
      silent = true,
      desc = "Search text starting from user input directory (grep search)",
    })

    vim.keymap.set({ "n", "x" }, "g/", function()
      snacks.picker.grep_word({
        buffers = true,
      })
    end, {
      noremap = true,
      silent = true,
      desc = "Search visual selection or word in all open buffers (grep word in open buffers)",
    })

    vim.keymap.set({ "n", "x" }, "<leader>g/", function()
      snacks.picker.grep_word({
        dirs = { vim.uv.cwd() },
        exclude = exclude_fext,
      })
    end, {
      noremap = true,
      silent = true,
      desc = "Search visual selection or word in current working directory (grep word in workspace)",
    })

    vim.keymap.set("n", "[/", "[<c-i>", {
      noremap = true,
      silent = true,
      desc = "Search for first occurrence of the current word (grep first occurrence of word)",
    })

    vim.keymap.set("n", "z=", function()
      if vim.opt_local.spell:get() then
        if vim.v.count == 0 then
          snacks.picker.spelling()
        else
          -- use count to select from suggestion list, e.g. 1z= to select the first item
          vim.cmd("normal! " .. vim.v.count .. "z=")
        end
      end
    end, {
      noremap = true,
      silent = true,
      desc = "Spell suggestions (if spellcheck is active)",
    })

    vim.keymap.set("n", "<leader>sm", function()
      snacks.picker.notifications()
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
      snacks.picker.projects()
    end, {
      noremap = true,
      silent = true,
      desc = "Search projects",
    })

    vim.keymap.set("n", "<leader>sT", function()
      snacks.picker.treesitter()
    end, {
      noremap = true,
      silent = true,
      desc = "Search treesitter symbols",
    })

    vim.keymap.set("n", "<leader>bd", function()
      snacks.bufdelete()
    end, {
      noremap = true,
      silent = true,
      desc = "Delete buffer (prompt for unsaved changes)",
    })

    vim.keymap.set("n", "grN", function()
      snacks.rename.rename_file({
        on_rename = function(to, from)
          -- vim.print("Old filename: " .. from .. ", New filename: " .. to)
          snacks.rename.on_rename_file(from, to)
        end,
      })
    end, {
      noremap = true,
      silent = true,
      desc = "Rename current buffer (inform LSP clients about the rename)",
    })

    vim.keymap.set("n", "<leader>gb", function()
      snacks.picker.git_branches()
    end, {
      noremap = true,
      silent = true,
      desc = "Switch git branches",
    })

    vim.keymap.set("n", "<leader>gd", function()
      snacks.picker.git_diff()
    end, {
      noremap = true,
      silent = true,
      desc = "Show git diff",
    })

    vim.keymap.set("n", "<leader>.", function()
      snacks.scratch()
    end, {
      noremap = true,
      silent = true,
      desc = "Toggle Scratch Buffer",
    })

    vim.keymap.set("n", "<leader>S", function()
      snacks.scratch.select()
    end, {
      noremap = true,
      silent = true,
      desc = "Select Scratch Buffer",
    })
  end,
}
