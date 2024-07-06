-- indent blank lines

local exc_filetypes = {
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
}

return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  main = "ibl",
  config = function()
    require("ibl").setup({
      exclude = {
        filetypes = exc_filetypes,
      },
      indent = { char = "┊", highlight = "IblIndent" },
      whitespace = {
        remove_blankline_trail = true,
      },
      scope = { enabled = true, show_start = false, show_end = false, highlight = "Title" },
    })
  end,
}
