return {
  "kiyoon/treesitter-indent-object.nvim",
  keys = {
    {
      "ai",
      "<cmd>lua require'treesitter_indent_object.textobj'.select_indent_outer()<cr>",
      mode = { "x", "o" },
      desc = "Select context-aware indent (outer)",
    },
    {
      "aI",
      "<cmd>lua require'treesitter_indent_object.textobj'.select_indent_outer(true)<cr>",
      mode = { "x", "o" },
      desc = "Select context-aware indent (outer, line-wise)",
    },
    {
      "ii",
      "<cmd>lua require'treesitter_indent_object.textobj'.select_indent_inner()<cr>",
      mode = { "x", "o" },
      desc = "Select context-aware indent (inner, partial range)",
    },
    {
      "iI",
      "<cmd>lua require'treesitter_indent_object.textobj'.select_indent_inner(true)<cr>",
      mode = { "x", "o" },
      desc = "Select context-aware indent (inner, entire range)",
    },
  },
}
