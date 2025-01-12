-- autopairs
return {
  "echasnovski/mini.pairs",
  event = "InsertEnter",
  version = false,
  config = function()
    require("mini.pairs").setup()
  end,
}
