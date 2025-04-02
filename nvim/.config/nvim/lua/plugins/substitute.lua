-- substitute (yank-and-replace and exchange textobjects)
return {
  "gbprod/substitute.nvim",
  event = "BufEnter",
  opts = {
    highlight_substituted_text = {
      enabled = true,
      timer = 700,
    },
  },
  init = function()
    vim.api.nvim_set_keymap("n", "cr", [[<cmd>lua require('substitute').operator()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Substitute (change-replace) selection (normal mode)",
    })

    vim.api.nvim_set_keymap("n", "crr", [[<cmd>lua require('substitute').line()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Substitute (change-replace) line",
    })

    vim.api.nvim_set_keymap("n", "crl", [[<cmd>lua require('substitute').eol()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Substitute (change-replace) end of line from cursor location",
    })

    vim.api.nvim_set_keymap("x", "cr", [[<cmd>lua require('substitute').visual()<cr>]], {
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
