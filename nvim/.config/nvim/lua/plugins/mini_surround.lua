return {
  "nvim-mini/mini.surround",
  version = false,
  event = "VeryLazy",
  config = function()
    require("mini.surround").setup({
      highlight_duration = 700,
    })
  end,
}
