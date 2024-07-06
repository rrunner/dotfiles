return {
  "rmagatti/goto-preview",
  enabled = false,
  config = function()
    require("goto-preview").setup({
      post_open_hook = function()
        vim.keymap.set("n", "q", "<cmd>close<cr>", { noremap = true, silent = true })
      end,
    })
  end,
  init = function()
    vim.keymap.set(
      "n",
      "<leader>gd",
      "<cmd>lua require('goto-preview').goto_preview_definition()<cr>",
      { noremap = true, desc = "Goto definition preview window" }
    )
    vim.keymap.set(
      "n",
      "<leader>gx",
      "<cmd>lua require('goto-preview').goto_preview_references()<cr>",
      { noremap = true, desc = "Goto references preview window" }
    )
  end,
}
