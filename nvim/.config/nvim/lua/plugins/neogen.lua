-- neogen (documentation)
return {
  "danymat/neogen",
  ft = "python",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    languages = {
      python = {
        template = {
          annotation_convention = "google_docstrings",
        },
      },
    },
  },
  init = function()
    vim.api.nvim_set_keymap("n", "<localleader>ds", [[<cmd>lua require('neogen').generate({ type = 'file' })<cr>]], {
      noremap = true,
      silent = true,
      desc = "Document file (with neogen)",
    })

    vim.api.nvim_set_keymap("n", "<localleader>df", [[<cmd>lua require('neogen').generate({ type = 'func' })<cr>]], {
      noremap = true,
      silent = true,
      desc = "Document func (with neogen)",
    })

    vim.api.nvim_set_keymap("n", "<localleader>dc", [[<cmd>lua require('neogen').generate({ type = 'class' })<cr>]], {
      noremap = true,
      silent = true,
      desc = "Document class (with neogen)",
    })
  end,
}
