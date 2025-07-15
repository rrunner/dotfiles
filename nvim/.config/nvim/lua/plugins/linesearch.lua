-- plugin to enable smart-case search on current line
return {
  "samiulsami/fFtT-highlights.nvim",
  event = "BufEnter",
  config = function()
    require("fFtT-highlights"):setup({
      f = "f",
      F = "F",
      t = "t",
      T = "T",
      next = ";",
      prev = ",",
      reset_key = "<esc>",
      smart_motions = false,
      case_sensitivity = "smart_case",
      match_highlight = {
        enable = false,
      },
      multi_line = {
        enable = false,
        max_lines = 50,
      },
      backdrop = {
        style = {
          on_key_press = "none",
          show_in_motion = "none",
        },
      },
      disabled_filetypes = {},
      disabled_buftypes = { "nofile" },
    })
  end,
}
