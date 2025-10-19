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
    vim.keymap.set("n", "cr", [[<cmd>lua require('substitute').operator()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Substitute (change-replace) selection (normal mode)",
    })

    vim.keymap.set("n", "crr", [[<cmd>lua require('substitute').line()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Substitute (change-replace) line",
    })

    vim.keymap.set("n", "crl", [[<cmd>lua require('substitute').eol()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Substitute (change-replace) end of line from cursor location",
    })

    vim.keymap.set("x", "cr", [[<cmd>lua require('substitute').visual()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Substitute (go-replace) selection (visual/select mode)",
    })

    vim.keymap.set("n", "cx", [[<cmd>lua require('substitute.exchange').operator()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Exchange selections",
    })

    vim.keymap.set("n", "cxx", [[<cmd>lua require('substitute.exchange').line()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Exchange line",
    })
  end,
}
