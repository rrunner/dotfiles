return {
  "stevearc/aerial.nvim",
  -- the aerial plugin is effectively loaded at startup because lualine uses aerial
  config = function()
    require("aerial").setup({
      layout = {
        max_width = { 40, 0.1 },
        min_width = 40,
      },
      -- filter_kind = false, -- display all symbols
      close_automatic_events = { "unfocus", "switch_buffer", "unsupported" },
      highlight_on_jump = 700,
      post_jump_cmd = "normal! zt",
      lazy_load = false,
      close_on_select = true,
      keymaps = {
        ["<c-v>"] = "actions.jump_vsplit",
        ["<c-x>"] = "actions.jump_split",
        ["<c-n>"] = "actions.down_and_scroll",
        ["<c-p>"] = "actions.up_and_scroll",
      },
      icons = icons._kinds_cmp,
    })

    vim.keymap.set("n", "<leader>ea", "<cmd>AerialToggle<cr>", { desc = "Aerial toogle (display LSP symbols)" })
  end,
}
