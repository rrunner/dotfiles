-- icons
require("mini.icons").setup({
  lsp = {
    -- override mini.icons defaults
    ["function"] = { glyph = "󰊕 ", hl = "MiniIconsAzure" },
    method = { glyph = "󰡱 ", hl = "MiniIconsAzure" },
    variable = { glyph = "󰫧 ", hl = "MiniIconsCyan" },
    value = { glyph = "󰀫 ", hl = "MiniIconsBlue" },
    constant = { glyph = "󰏿 ", hl = "MiniIconsOrange" },
    -- icons to represent blink-cmp-words completion items
    dictionary = { glyph = "󰍉 ", hl = "MiniIconsRed" },
    thesaurus = { glyph = " ", hl = "MiniIconsRed" },
    -- icons available in Snacks (in camel case) but not in mini.icons
    staticmethod = { glyph = "󰡱 ", hl = "MiniIconsAzure" },
    copilot = { glyph = " ", hl = "MiniIconsPurple" },
    unknown = { glyph = " ", hl = "MiniIconsRed" },
    collapsed = { glyph = " ", hl = "MiniIconsGrey" },
    parameter = { glyph = " ", hl = "MiniIconsCyan" },
  },
})
