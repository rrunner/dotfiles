-- colorschemes
-- set lazy to true for all colourschemes below to use the default nvim colourscheme
return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      require("tokyonight").setup()
      vim.cmd.colorscheme("tokyonight-moon")
      -- vim.cmd.colorscheme("tokyonight-storm")
      -- vim.cmd.colorscheme("tokyonight-night")
      -- vim.cmd.colorscheme("tokyonight-day")
    end,
  },
  {
    "neanias/everforest-nvim",
    lazy = true,
    priority = 1000,
    config = function()
      require("everforest").setup({
        --  "soft", "medium" or "hard"
        background = "hard",
      })
      vim.cmd.colorscheme("everforest")
    end,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox").setup({
        options = {
          styles = {
            comments = "italic",
            keywords = "bold",
            types = "italic,bold",
          },
        },
      })
      -- available themes: nightfox, dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox
      vim.cmd.colorscheme("nordfox")
    end,
  },
  {
    "webhooked/kanso.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      require("kanso").setup({
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        disableItalics = false,
        -- available themes: zen, ink, pearl
        theme = "zen",
        background = {
          dark = "zen",
          light = "pearl",
        },
      })
      vim.cmd.colorscheme("kanso")
    end,
  },
}
