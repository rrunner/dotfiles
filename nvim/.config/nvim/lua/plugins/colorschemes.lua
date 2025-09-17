-- colorschemes
-- set lazy=false/true to enable/disable colourscheme (set lazy=true for all to use default colorscheme)
return {
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
}
