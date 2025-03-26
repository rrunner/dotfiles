return {
  "stevearc/aerial.nvim",
  -- no lazy load since the aerial plugin is effectively loaded at startup because of lualine integration configuration
  config = function()
    require("aerial").setup({
      show_guides = true,
      backends = { "treesitter", "markdown" },
      layout = {
        max_width = { 40, 0.1 },
        min_width = 40,
      },
      disable_max_lines = 20000,
      -- filter_kind = false, -- display all symbols
      highlight_closest = false,
      highlight_on_jump = 700,
      highlight_on_hover = true,
      post_jump_cmd = "normal! zt",
      lazy_load = false,
      close_on_select = false,
      manage_folds = true, -- align folds between buffer and aerial
      link_folds_to_tree = true,
      link_tree_to_folds = true,
      keymaps = {
        ["<c-v>"] = "actions.jump_vsplit",
        ["<c-x>"] = "actions.jump_split",
        ["<c-n>"] = "actions.down_and_scroll",
        ["<c-p>"] = "actions.up_and_scroll",
        ["<c-c>"] = "actions.close",
        ["o"] = "actions.tree_toggle",
        ["O"] = "actions.tree_toggle_recursive",
        ["l"] = "actions.tree_open",
        ["L"] = "actions.tree_open_recursive",
        ["h"] = "actions.tree_close",
        ["H"] = "actions.tree_close_recursive",
      },
      icons = icons._kinds_cmp,
    })

    vim.keymap.set(
      "n",
      "<leader>ea",
      "<cmd>AerialToggle<cr>",
      { desc = "Aerial toogle (display treesitter/markdown symbols)" }
    )
  end,
}
