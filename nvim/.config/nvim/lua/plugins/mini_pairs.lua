-- autopairs
return {
  "echasnovski/mini.pairs",
  event = "VeryLazy",
  version = false,
  config = function()
    require("mini.pairs").setup({
      modes = { insert = true, command = true, terminal = false },
    })
  end,
}
