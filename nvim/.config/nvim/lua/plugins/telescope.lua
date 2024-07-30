-- telescope
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  event = "VimEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      -- fuzzy finder algorithm used by telescope
      "nvim-telescope/telescope-fzf-native.nvim",
      enabled = vim.fn.executable("make") == 1 or vim.fn.executable("cmake") == 1,
      build = vim.fn.executable("make") == 1 and "make"
        or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },
    { "nvim-telescope/telescope-live-grep-args.nvim" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local actions_layout = require("telescope.actions.layout")
    local utils = require("config.utils")

    telescope.setup({
      defaults = {
        dynamic_preview_title = true,
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            height = 0.8,
            preview_cutoff = 60,
            prompt_position = "top",
            width = 0.9,
          },
        },
        preview = {
          hide_on_startup = true,
        },
        prompt_prefix = " ",
        selection_caret = "󰼛 ",
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        },
        mappings = {
          i = {
            ["<c-n>"] = actions.move_selection_next,
            ["<c-p>"] = actions.move_selection_previous,
            ["<c-e>"] = actions.close,
            ["<cr>"] = actions.select_default,
            ["<c-h>"] = false,
            ["<c-j>"] = actions.nop,
            ["<c-k>"] = actions.nop,
            ["<c-d>"] = actions.nop,
            ["<c-u>"] = false,
            ["<c-v>"] = actions.select_vertical,
            ["<c-x>"] = actions.select_horizontal,
            -- enable actions below when included in next stable version of telescope
            -- ["<m-h>"] = actions.preview_scrolling_left,
            -- ["<m-j>"] = actions.preview_scrolling_down,
            -- ["<m-k>"] = actions.preview_scrolling_up,
            -- ["<m-l>"] = actions.preview_scrolling_right,
            ["<tab>"] = actions.toggle_selection,
            ["<s-tab>"] = actions.toggle_selection,
            -- ["<c-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<c-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            ["<c-/>"] = actions.which_key,
            ["?"] = actions_layout.toggle_preview,
          },
          n = {
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["<esc>"] = actions.close,
            ["<cr>"] = actions.select_default,
            ["x"] = actions.select_horizontal,
            ["v"] = actions.select_vertical,
            ["<tab>"] = actions.toggle_selection,
            ["<s-tab>"] = actions.toggle_selection,
            ["q"] = actions.send_to_qflist + actions.open_qflist,
            ["/"] = actions.which_key,
            ["?"] = actions_layout.toggle_preview,
          },
        },
        extensions = {
          fzf = {},
          live_grep_args = {},
        },
      },
      pickers = {
        buffers = {
          theme = "dropdown",
          show_all_buffers = true,
          sort_mru = true,
          mappings = {
            i = {
              ["<c-d>"] = actions.delete_buffer,
              ["<cr>"] = utils.open_buffer,
            },
          },
        },
        lsp_document_symbols = {
          preview = {
            hide_on_startup = false,
          },
        },
        lsp_dynamic_workspace_symbols = {
          preview = {
            hide_on_startup = false,
          },
        },
        find_files = {
          path_display = {
            filename_first = {
              reverse_directories = false,
            },
            shorten = { len = 2, exclude = { 1, -2, -1 } },
          },
        },
        oldfiles = {
          path_display = function(_, path)
            local tail = require("telescope.utils").path_tail(path)
            return string.format("%s (%s)", tail, path)
          end,
        },
        grep_string = {
          preview = {
            hide_on_startup = false,
          },
        },
        quickfix = {
          preview = {
            hide_on_startup = false,
          },
        },
        lsp_definitions = {
          mappings = {
            i = {
              ["<cr>"] = function(prompt_bufnr)
                require("telescope.actions").select_default(prompt_bufnr)
                vim.cmd([[normal! zt]])
              end,
            },
          },
        },
        lsp_references = {
          preview = {
            hide_on_startup = false,
          },
          mappings = {
            i = {
              ["<cr>"] = function(prompt_bufnr)
                require("telescope.actions").select_default(prompt_bufnr)
                vim.cmd([[normal! zt]])
              end,
            },
          },
        },
        live_grep = {
          preview = {
            hide_on_startup = false,
          },
        },
        help_tags = {
          preview = {
            hide_on_startup = false,
          },
        },
        git_status = {
          mappings = {
            i = {
              ["<tab>"] = actions.git_staging_toggle,
              ["<c-t>"] = false,
            },
            n = {
              ["<c-t>"] = false,
            },
          },
          preview = {
            hide_on_startup = false,
          },
        },
      },
    })

    -- enable telescope fzf native if installed
    pcall(require("telescope").load_extension, "fzf")
    -- enable live grep args picker
    pcall(require("telescope").load_extension, "live_grep_args")
  end,
  init = function()
    vim.api.nvim_set_keymap(
      "n",
      "<leader>gg",
      [[<cmd>lua require("telescope.builtin").git_status({ use_git_root = true, git_icons = require("config.icons").git_icons })<cr>]],
      {
        noremap = true,
        silent = true,
        desc = "Git status using Telescope (use <tab> to stage/unstage files)",
      }
    )

    vim.api.nvim_set_keymap(
      "n",
      "<c-tab>",
      [[<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_cursor({show_all_buffers=true, ignore_current_buffer=true, only_cwd=false, sort_mru=true}))<cr>]],
      {
        noremap = true,
        silent = true,
        desc = "Search/list all buffers (except the current buffer) with priority for most recently used buffers",
      }
    )

    vim.api.nvim_set_keymap("n", "<leader>sb", [[<cmd>lua require('telescope.builtin').buffers()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Search/list all buffers",
    })

    vim.api.nvim_set_keymap(
      "n",
      "<leader>sf",
      [[<cmd>lua require("config.utils").telescope_files_or_git_files()<cr>]],
      {
        noremap = true,
        silent = true,
        desc = "Search files (git files if inside git repo)",
      }
    )

    vim.api.nvim_set_keymap("n", "<leader>sg", [[<cmd>lua require("config.utils").telescope_live_grep_in_path()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Search text from dir (user input optional)",
    })

    vim.api.nvim_set_keymap("n", "<leader>sa", [[<cmd>lua require("config.utils").telescope_live_grep_args()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Search text from dir using (rip)grep args (user input optional)",
    })

    vim.api.nvim_set_keymap(
      "n",
      "<leader>sl",
      [[<cmd>lua require('telescope.builtin').live_grep({grep_open_files=true})<cr>]],
      {
        noremap = true,
        silent = true,
        desc = "Search lines across open buffers",
      }
    )

    vim.api.nvim_set_keymap("n", "<leader>sh", [[<cmd>lua require('telescope.builtin').help_tags()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Search help (help tags)",
    })

    vim.api.nvim_set_keymap("n", "<leader>so", [[<cmd>lua require('telescope.builtin').oldfiles()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Search old files (recently opened files)",
    })

    vim.api.nvim_set_keymap("n", "<leader>sn", [[<cmd>lua require("config.utils").search_notes()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Search for notes (or start from template)",
    })

    vim.api.nvim_set_keymap("n", "<leader>ss", [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Search for LSP document symbols",
    })

    vim.api.nvim_set_keymap(
      "n",
      "<leader>sw",
      [[<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>]],
      {
        noremap = true,
        silent = true,
        desc = "Search for LSP dynamic workspace symbols",
      }
    )

    vim.api.nvim_set_keymap("n", "<leader>sm", [[<cmd>lua require('telescope').extensions.notify.notify()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Search for messages (notifications)",
    })

    vim.api.nvim_set_keymap("n", "<leader>sk", [[<cmd>lua require('telescope.builtin').keymaps()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Search for normal mode keymaps",
    })

    vim.api.nvim_set_keymap(
      "n",
      "<leader>sd",
      [[<cmd>lua require('telescope.builtin').find_files({cwd="~/.config/nvim/"})<cr>]],
      {
        noremap = true,
        silent = true,
        desc = "Search neovim configuration (dot) files",
      }
    )

    vim.api.nvim_set_keymap(
      "n",
      "<leader>st",
      [[<cmd>lua require("telescope.builtin").grep_string({search_dirs={vim.fn.expand("%:p")}})<cr>]],
      {
        noremap = true,
        silent = true,
        desc = "Search for string under cursor in current file",
      }
    )

    vim.api.nvim_set_keymap(
      "n",
      "<leader>s/",
      [[<cmd>lua require("telescope.builtin").grep_string({grep_open_files=true})<cr>]],
      {
        noremap = true,
        silent = true,
        desc = "Search for string under cursor in all open files",
      }
    )

    vim.api.nvim_set_keymap("n", "<leader>sc", [[<cmd>lua require("telescope.builtin").grep_string()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Search for string under cursor in current working directory (cwd)",
    })

    vim.api.nvim_set_keymap("n", "<leader>sr", [[<cmd>lua require('telescope.builtin').resume()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Search resume (resume last telescope search)",
    })

    vim.api.nvim_set_keymap("n", "<leader>sq", [[<cmd>lua require('telescope.builtin').quickfix()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Search quickfix",
    })

    vim.keymap.set("n", "z=", function()
      if vim.opt_local.spell:get() then
        require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor({}))
      end
    end, {
      noremap = true,
      silent = true,
      desc = "Spell suggestions displayed at the cursor (if spellcheck is active)",
    })
  end,
}
