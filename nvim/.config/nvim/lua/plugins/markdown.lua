-- markdown viewer
local supported_filetypes = { "rmd", "markdown", "quarto" }

return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = supported_filetypes,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local icons = require("config.icons")
    require("render-markdown").setup({
      file_types = supported_filetypes,
      heading = {
        sign = false,
        icons = {},
      },
      code = {
        sign = false,
        width = "block",
        right_pad = 5,
      },
      bullet = {
        icons = icons.bullets,
      },
      checkbox = {
        enabled = false,
      },
    })
    vim.treesitter.language.register("markdown", "quarto")
    vim.treesitter.language.register("markdown", "rmd")
  end,
}
