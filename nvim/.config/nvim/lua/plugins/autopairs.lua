-- autopairs
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local npairs = require("nvim-autopairs")
    npairs.setup({
      check_ts = false,
      disable_filetype = { "TelescopePrompt" },
      disable_in_macro = true,
      map_cr = true,
      map_bs = true,
      map_c_h = true,
      map_c_w = true,
    })
  end,
}
