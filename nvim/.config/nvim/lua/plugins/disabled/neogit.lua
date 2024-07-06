-- git integration
return {
  "NeogitOrg/neogit",
  cond = vim.fn.executable("git") == 1,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      -- optional dependency
      {
        "sindrets/diffview.nvim",
        cond = vim.fn.executable("git") == 1,
      },
    },
  },
  config = function()
    local opts_neogit = {
      disable_commit_confirmation = true,
      kind = "vsplit",
      disable_line_numbers = false,
      commit_view = {
        kind = "vsplit",
        verify_commit = vim.fn.exepath("gpg") ~= "",
      },
      integrations = {
        telescope = nil, -- use dressing to select telescope
        diffview = true,
      },
      mappings = {
        finder = {
          ["<cr>"] = "Select",
          ["<c-e>"] = "Close",
          ["<esc>"] = "Close",
          ["<c-n>"] = "Next",
          ["<c-p>"] = "Previous",
          ["<down>"] = "Next",
          ["<up>"] = "Previous",
          ["<tab>"] = "MultiselectToggleNext",
          ["<s-tab>"] = "MultiselectTogglePrevious",
          ["<c-j>"] = "NOP",
          ["<c-k>"] = "NOP",
        },
        status = {
          ["o"] = "Toggle",
          ["[g"] = "GoToPreviousHunkHeader",
          ["]g"] = "GoToNextHunkHeader",
        },
      },
    }
    require("neogit").setup(opts_neogit)

    -- close neo-tree/aerial if neogit opens
    local config_neogit = vim.api.nvim_create_augroup("ConfigNeogit", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        local exists_neotree, cmd_neotree = pcall(require, "neo-tree.command")
        if exists_neotree then
          cmd_neotree.execute({ action = "close" })
        end
        local exists_aerial, cmd_aerial = pcall(require, "aerial")
        if exists_aerial then
          cmd_aerial.close_all()
        end
      end,
      group = config_neogit,
      pattern = { "NeogitStatus" },
    })

    local opts_diffview = {
      hooks = {
        diff_buf_read = function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.signcolumn = "no"
          vim.opt_local.statuscolumn = ""
          vim.opt_local.fillchars:append({ diff = "/" })
        end,
      },
      keymaps = {
        disable_defaults = false,
        file_panel = {
          { "n", "q", ":DiffviewClose<cr>", { silent = true, noremap = true, desc = "Close diffview" } },
        },
        file_history_panel = {
          { "n", "q", ":DiffviewClose<cr>", { silent = true, noremap = true, desc = "Close diffview" } },
        },
      },
    }
    require("diffview").setup(opts_diffview)
  end,
  init = function()
    vim.api.nvim_set_keymap("n", "<localleader>gg", [[<cmd>lua require('neogit').open()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Open neogit (to perform common git operations)",
    })

    vim.api.nvim_set_keymap("n", "<localleader>gl", [[<cmd>lua require('neogit').open({"log"})<cr>]], {
      noremap = true,
      silent = true,
      desc = "Open neogit log",
    })

    vim.api.nvim_set_keymap("n", "<localleader>gd", [[<cmd>DiffviewOpen<cr>]], {
      noremap = true,
      silent = true,
      desc = "Open diffview (git diff compared to index)",
    })
  end,
}
