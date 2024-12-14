return {
  {
    "stevearc/oil.nvim",
    event = "BufEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local oil = require("oil")
      oil.setup({
        columns = { "icon" },
        use_default_keymaps = false,
        keymaps = {
          ["q"] = {
            function()
              oil.close({ exit_if_last_buf = true })
            end,
            opts = {},
            desc = "Close oil buffer (also nvim if last buffer)",
          },
          ["h"] = "actions.toggle_hidden",
          ["<cr>"] = "actions.select",
          ["<c-h>"] = false,
          ["<c-v>"] = "actions.select_vsplit",
          ["<c-x>"] = "actions.select_split",
          ["-"] = "actions.parent",
        },
        view_options = {
          show_hidden = true,
        },
      })

      vim.keymap.set("n", "<leader>eo", function()
        require("oil").open()
      end, { desc = "Open the parent of the current buffer (using oil)" })
    end,
  },
}
