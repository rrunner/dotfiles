-- split/join expressions
return {
  "Wansmer/treesj",
  keys = {
    { "gJ", [[<cmd>TSJJoin<cr>]], mode = "n", desc = "Join blocks of code", noremap = true, silent = true },
    { "gS", [[<cmd>TSJSplit<cr>]], mode = "n", desc = "Split blocks of code", noremap = true, silent = true },
  },
  dependencies = { "nvim-treesitter" },
  -- dir = "~/projects/treesj",
  opts = {
    use_default_keymaps = false,
    max_join_length = 100,
    dot_repeat = true,
    -- default configuration for languages
    langs = {},
  },
}
