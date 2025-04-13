-- `lazydev` configures Lua LSP for the nvim config, runtime and plugins
return {
  enabled = true,
  "folke/lazydev.nvim",
  ft = "lua",
  -- cmd = "LazyDev",
  opts = {
    library = {
      -- load luvit types when the `vim.uv` word is found
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "snacks.nvim", words = { "Snacks" } },
    },
  },
}
