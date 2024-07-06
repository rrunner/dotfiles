-- rainbow parentheses
return {
  "HiPhish/rainbow-delimiters.nvim",
  enabled = false,
  config = function()
    local rainbow_delimiters = require("rainbow-delimiters")

    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = rainbow_delimiters.strategy["local"],
        -- r = rainbow_delimiters.strategy["global"],
        -- latex = function()
        --   -- dynamic for latex files
        --   if vim.fn.line("$") > 10000 then
        --     return nil
        --   elseif vim.fn.line("$") > 1000 then
        --     return rainbow_delimiters.strategy["global"]
        --   end
        --   return rainbow_delimiters.strategy["local"]
        -- end,
      },
      query = {
        [""] = "rainbow-delimiters",
        -- lua = "rainbow-blocks",
      },
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      },
      blacklist = {},
    }
  end,
}
