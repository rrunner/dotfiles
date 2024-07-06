-- substitute (go-replace)
return {
  "gbprod/substitute.nvim",
  event = "BufEnter",
  config = true, -- start plugin with empty config
  init = function()

    vim.api.nvim_set_keymap("n", "gr", [[<cmd>lua require('substitute').operator()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Substitute (go-replace) selection (normal mode)",
    })

    vim.api.nvim_set_keymap("n", "grr", [[<cmd>lua require('substitute').line()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Substitute (go-replace) line",
    })

    vim.api.nvim_set_keymap("n", "grl", [[<cmd>lua require('substitute').eol()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Substitute (go-replace) end of line from cursor location",
    })

    vim.api.nvim_set_keymap("x", "gr", [[<cmd>lua require('substitute').visual()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Substitute (go-replace) selection (visual/select mode)",
    })

    vim.api.nvim_set_keymap("n", "cx", [[<cmd>lua require('substitute.exchange').operator()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Exchange selections",
    })

    vim.api.nvim_set_keymap("n", "cxx", [[<cmd>lua require('substitute.exchange').line()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Exchange line",
    })
  end,
}
