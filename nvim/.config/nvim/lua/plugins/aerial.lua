return {
  "stevearc/aerial.nvim",
  -- no lazy load since the aerial plugin is effectively loaded at startup because of lualine configuration
  config = function()
    require("aerial").setup({
      layout = {
        max_width = { 40, 0.1 },
        min_width = 40,
      },
      disable_max_lines = 20000,
      -- filter_kind = false, -- display all symbols
      -- close_automatic_events = { "unfocus", "switch_buffer", "unsupported" },
      close_automatic_events = {},
      highlight_on_jump = 700,
      highlight_on_hover = true,
      post_jump_cmd = "normal! zt",
      lazy_load = false,
      close_on_select = false,
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
