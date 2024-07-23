-- `lazydev` configures Lua LSP for the nvim config, runtime and plugins
return {
  "folke/lazydev.nvim",
  ft = "lua",
  dependencies = {
    "Bilal2453/luvit-meta",
    lazy = true,
  },
  opts = {
    library = {
      -- load luvit types when the `vim.uv` word is found
      { path = "luvit-meta/library", words = { "vim%.uv" } },
    },
  },
}
