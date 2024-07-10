-- mark indentation/scope with vertical line
return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  main = "ibl",
  config = function()
    require("ibl").setup({
      exclude = {
        filetypes = {
          "lspinfo",
          "checkhealth",
          "help",
          "man",
          "text",
          "",
          "noice",
          "lazy",
          "neo-tree",
          "qf",
          "TelescopePrompt",
          "TelescopeResults",
          "gitcommit",
          "DressingInput",
          "DressingSelect",
        },
      },
      indent = { char = "┊", highlight = "IblIndent" },
      whitespace = {
        remove_blankline_trail = true,
      },
      scope = { enabled = true, show_start = false, show_end = false, highlight = "Title" },
    })
  end,
}
