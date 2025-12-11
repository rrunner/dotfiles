return {
  "nvim-mini/mini.icons",
  version = false,
  config = function()
    require("mini.icons").setup({
      lsp = {
        -- icons to represent blink-cmp-words completion items
        dictionary = { glyph = '󰍉 ' },
        thesaurus = { glyph = ' ' },
      },
    })
  end,
}
