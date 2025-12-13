-- colorschemes
-- set lazy=true for all to use default colorscheme
return {
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
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
    "lucasadelino/conifer.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      require("conifer").setup({
        variant = "lunar",   -- "lunar" for dark, "solar" for light
        transparent = false, -- whether to set the bg color for the lunar variant
        styles = {
          comments = {},
          functions = {},
          keywords = {},
          lsp = {},
          match_paren = { underline = false, link = "Title" },
          type = { bold = false },
          variables = {},
        },
      })
      vim.cmd.colorscheme("conifer")
      -- hide the win separator
      local color = vim.o.background == "dark" and "#161716" or "#E8E8C2"
      vim.api.nvim_set_hl(0, "WinSeparator", { bg = color, fg = color })
    end,
  },
  {
    "gbprod/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local colors = require("nord.colors")
      require("nord").setup({
        borders = false,
        diff = { mode = "fg" },
      })
      vim.cmd.colorscheme("nord")
      vim.api.nvim_set_hl(0, "WarningMsg", { bg = colors.default_bg, fg = colors.palette.aurora.yellow })
      vim.api.nvim_set_hl(0, "ErrorMsg", { bg = colors.default_bg, fg = colors.palette.aurora.red })
    end,
  },
}
