return {
  "otavioschwanck/arrow.nvim",
  enabled = false,
  event = "BufReadPost",
  config = function()
    local statusline = require("arrow.statusline")
    statusline.text_for_statusline_with_icons()
    require("arrow").setup({
      show_icons = true,
      leader_key = "<tab>",
      mappings = {
        edit = "e",
        delete_mode = "d",
        clear_all_items = "C",
        toggle = "s",
        open_vertical = "v",
        open_horizontal = "x",
        quit = "q",
      },
    })
  end,
  init = function()
    vim.keymap.set("n", "[a", [[<cmd>lua require("arrow.persist").previous()<cr>]])
    vim.keymap.set("n", "]a", [[<cmd>lua require("arrow.persist").next()<cr>]])
  end,
}
