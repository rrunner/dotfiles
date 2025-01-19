-- rename LSP symbols
return {
  enabled = false,
  "smjonas/inc-rename.nvim",
  event = "LspAttach",
  config = function()
    require("inc_rename").setup({})
  end,
}
