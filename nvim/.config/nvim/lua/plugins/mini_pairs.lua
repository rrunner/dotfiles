-- autopairs
return {
  "echasnovski/mini.pairs",
  event = "VeryLazy",
  version = false,
  config = function()
    require("mini.pairs").setup({
      modes = { insert = true, command = true, terminal = false },
      mappings = {
        -- better for python docstrings
        ['"'] = { action = "closeopen", pair = '""', neigh_pattern = '[^\\"].', register = { cr = false } },
      },
    })
  end,
}
