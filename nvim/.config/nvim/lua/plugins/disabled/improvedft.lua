-- improved f,t,F,T (respect smartcase and does multiline search)
return {
  "backdround/improved-ft.nvim",
  event = "VeryLazy",
  config = function()
    local ift = require("improved-ft")

    local iftmap = function(key, fn, description)
      vim.keymap.set({ "n", "x", "o" }, key, fn, {
        desc = description,
        expr = true,
      })
    end

    iftmap("f", ift.hop_forward_to_char, "Hop forward to a given char")
    iftmap("F", ift.hop_backward_to_char, "Hop backward to a given char")
    iftmap("t", ift.hop_forward_to_pre_char, "Hop forward before a given char")
    iftmap("T", ift.hop_backward_to_pre_char, "Hop backward before a given char")
    iftmap(";", ift.repeat_forward, "Repeat hop forward to a last given char")
    iftmap(",", ift.repeat_backward, "Repeat hop backward to a last given char")

    ift.setup({
      use_default_mappings = false,
      ignore_char_case = true,
      use_relative_repetition = true,
    })
  end,
}
