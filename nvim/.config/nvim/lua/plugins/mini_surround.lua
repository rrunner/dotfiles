return {
  "nvim-mini/mini.surround",
  version = false,
  config = function()
    require("mini.surround").setup({
      highlight_duration = 700,
    })
  end,
}
