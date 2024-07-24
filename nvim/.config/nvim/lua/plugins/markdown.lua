-- markdown viewer
local supported_filetypes = { "rmd", "markdown", "quarto" }

return {
  "MeanderingProgrammer/markdown.nvim",
  ft = supported_filetypes,
  main = "render-markdown",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("render-markdown").setup({
      file_types = supported_filetypes,
      heading = {
        sign = false,
      },
      code = {
        sign = false,
      },
    })
    vim.treesitter.language.register("markdown", "quarto")
  end,
}
