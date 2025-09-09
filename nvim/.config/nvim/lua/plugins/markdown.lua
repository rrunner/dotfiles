-- markdown viewer
local supported_filetypes = { "rmd", "markdown", "quarto" }

return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = supported_filetypes,
  dependencies = {
    { "nvim-treesitter/nvim-treesitter", branch = "main" },
    { "nvim-mini/mini.icons", version = false },
  },
  config = function()
    local icons = require("config.icons")
    local rendermd = require("render-markdown")
    rendermd.setup({
      file_types = supported_filetypes,
      heading = {
        sign = false,
        icons = {},
      },
      code = {
        sign = false,
        width = "block",
        right_pad = 5,
        language_name = false,
        border = "thick",
      },
      bullet = {
        icons = icons.bullets,
      },
      checkbox = {
        enabled = false,
      },
      anti_conceal = {
        -- show text that is normally concealed for the cursorline
        enabled = true,
        above = 0,
        below = 0,
      },
      html = {
        enabled = true,
        comment = {
          conceal = true,
          text = "html comment",
        },
      },
      overrides = {
        buflisted = {},
        buftype = {
          -- overrides for LSP hover window
          nofile = {
            code = {
              width = "full",
              language_name = true,
              disable_background = true,
            },
            anti_conceal = { enabled = false },
          },
        },
        filetype = {},
      },
    })

    vim.keymap.set("n", "<localleader>tm", function()
      rendermd.buf_toggle()
    end, { desc = "Toggle markdown plugin in current buffer", noremap = true, silent = true })
  end,
}
