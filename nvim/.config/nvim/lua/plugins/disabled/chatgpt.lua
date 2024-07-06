return {
  enabled = false,
  cond = function()
    local utils = require("config.utils")

    -- not use at work (curl issues...?)
    return utils.IS_LINUX and not utils.IS_WSL
  end,
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  config = function()
    require("chatgpt").setup({
      edit_with_instructions = {
        diff = false,
        keymaps = {
          close = "<c-e>",
          toggle_help = "<c-/>",
        },
      },
      chat = {
        keymaps = {
          close = "<c-e>",
          toggle_help = "<c-/>",
        },
      },
    })
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
}
