-- file explorer
return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    {
      "<leader>ex",
      [[<cmd>Neotree toggle=true<cr>]],
      mode = "n",
      desc = "Open or close the file explorer (Neotree)",
      noremap = true,
      silent = true,
    },
  },
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    local utils = require("config.utils")

    -- remove the deprecated commands from v1.x
    vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

    require("neo-tree").setup({
      close_if_last_window = true,
      use_default_mappings = false,

      -- collapse/uncollapse folder symbols
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },

      sources = {
        "filesystem",
      },

      -- window options
      window = {
        position = "right",
        width = 40,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["<cr>"] = "open",
          ["o"] = "toggle_node",
          ["x"] = "open_split",
          ["v"] = "open_vsplit",
          [";"] = "next_source",
          [","] = "prev_source",
          ["q"] = "close_window",
          ["r"] = "rename",
          ["<esc>"] = "cancel",
          ["<c-/>"] = "show_help",
        },
      },

      -- source filesystem
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
          -- only works on Windows for hidden files/directories
          hide_hidden = false,
          never_show = {
            ".DS_Store",
            "thumbs.db",
            ".mypy_cache",
            "__pycache__",
          },
        },
        follow_current_file = {
          enabled = true,
        },
        -- this will use the OS level file watchers to detect changes
        use_libuv_file_watcher = true,
        window = {
          mappings = {
            ["<bs>"] = "navigate_up",
            ["H"] = "toggle_hidden",
            ["/"] = "fuzzy_finder",
            ["a"] = "add",
            ["A"] = "add_directory",
            ["d"] = "delete",
            ["y"] = "copy_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["m"] = "cut_to_clipboard",
            ["[g"] = "prev_git_modified",
            ["]g"] = "next_git_modified",
            ["i"] = "show_file_details",
            ["sc"] = { "order_by_created", nowait = false },
            ["sd"] = { "order_by_diagnostics", nowait = false },
            ["sm"] = { "order_by_modified", nowait = false },
            ["sn"] = { "order_by_name", nowait = false },
            ["ss"] = { "order_by_size", nowait = false },
            ["st"] = { "order_by_type", nowait = false },
          },
        },
      },

      -- actions after open/close
      event_handlers = {
        {
          event = "neo_tree_window_after_open",
          handler = function(args)
            -- make remaining windows equal
            if args.position == "left" or args.position == "right" then
              vim.cmd("wincmd =")
            end

            -- reset debugger windows if DAP is running
            if utils.is_debugger_running() then
              local exists_dapui, dapui = pcall(require, "dapui")
              if exists_dapui and utils.is_debugger_running() then
                dapui.open({ reset = true })
              end
            end
          end,
        },
        {
          event = "neo_tree_window_after_close",
          handler = function(args)
            -- make remaining windows equal
            if args.position == "left" or args.position == "right" then
              vim.cmd("wincmd =")
            end

            -- reset debugger windows if DAP is running
            if utils.is_debugger_running() then
              local exists_dapui, dapui = pcall(require, "dapui")
              if exists_dapui and utils.is_debugger_running() then
                dapui.open({ reset = true })
              end
            end
          end,
        },
      },
    })
  end,
}
