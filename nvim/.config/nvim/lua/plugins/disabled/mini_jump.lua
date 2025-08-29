return {
  "nvim-mini/mini.jump",
  version = false,
  config = function()
    require("mini.jump").setup({
      mappings = {
        forward = "f",
        backward = "F",
        forward_till = "t",
        backward_till = "T",
        repeat_jump = "",
      },
      delay = {
        highlight = 10 ^ 7,
      },
    })
  end,
}
