return {
  {
    "stevearc/oil.nvim",
    event = "BufEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        columns = { "icon" },
        use_default_keymaps = true,
        keymaps = {
          ["q"] = "actions.close",
          ["h"] = "actions.toggle_hidden",
          ["<cr>"] = "actions.select",
          ["<c-h>"] = false,
          ["<c-v>"] = "actions.select_vsplit",
          ["<c-x>"] = "actions.select_split",
        },
        view_options = {
          show_hidden = true,
        },
      })

      -- vim.keymap.set("n", "<leader>eo", function()
      --   require("oil").toggle_float()
      -- end, { desc = "Open the parent of the current buffer in floating window (using oil)" })

      vim.keymap.set("n", "<leader>eo", function()
        require("oil").open()
      end, { desc = "Open the parent of the current buffer (using oil)" })
    end,
  },
}
