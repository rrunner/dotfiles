return {
  "stevearc/dressing.nvim",
  config = function()
    require("dressing").setup({
      input = {
        title_pos = "center",
        relative = "editor",
        win_options = {
          winblend = 0,
          sidescrolloff = 3,
        },
        mappings = {
          i = {
            -- must reset mappings in completion.lua (see DressingInput filetype mappings)
            ["<c-n>"] = false,
            ["<c-p>"] = false,
            ["<c-e>"] = "Close",
          },
        },
      },
      select = {
        backend = { "telescope", "builtin", "nui" },
      },
    })
  end,
}
