-- requires hurl to be installed on the system
return {
  "jellydn/hurl.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  ft = "hurl",
  -- do not use preset keybindings
  keys = {},
  config = function()
    require("hurl").setup({
      debug = false,
      show_notification = false,
      mode = "split",
      env_file = {
        -- add environment variables to this file
        ".env",
      },
      formatters = {
        json = { "jq" },
        html = {
          "prettier",
          "--parser",
          "html",
        },
      },
    })
  end,
}
