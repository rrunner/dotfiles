-- byte-compile and cache lua files/modules
vim.loader.enable()

-- define global configuration table
_G.Config = {}

-- use exploratory UI
require("vim._core.ui2").enable({})

-- set global variables
vim.g.mapleader = " "
vim.g.maplocalleader = "-"
vim.g.is_github_blocked = false -- block github usage
vim.g.is_github_not_blocked = not vim.g.is_github_blocked
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.clipboard = "xclip"
vim.g.py_root_markers = { { "pyproject.toml", "uv.lock" }, "requirements.txt", "Pipfile" }

-- enable built-in plugins
vim.g.editorconfig = true
vim.cmd.packadd("nvim.undotree") -- :Undotree
vim.cmd.packadd("nvim.difftool") -- :DiffTool <folder1|file1> <folder2|file2>

-- disable built-in plugins
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_netrwPlugin = 1

-- user plugins
vim.pack.add({
  -- dependencies
  -- strict dependencies (not directly required by user configuration)
  { src = "https://github.com/nvim-neotest/nvim-nio" }, -- required by nvim-dap-ui, neotest
  { src = "https://github.com/nvim-lua/plenary.nvim" }, -- required by neotest
  -- treesitter (core functionality and main plugin dependency)
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },

  -- icons (required by user configuration)
  {
    src = "https://github.com/nvim-mini/mini.icons",
    version = "main",
  }, -- required by blink.cmp, render-markdown.nvim, slimline.nvim

  -- plugins
  { src = "https://github.com/gbprod/nord.nvim" },
  { src = "https://github.com/folke/snacks.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/nvim-mini/mini-git", version = "main" },
  { src = "https://github.com/spacedentist/resolve.nvim" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/archie-judd/blink-cmp-words" },
  { src = "https://github.com/mayromr/blink-cmp-dap" },
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("1"),
  },
  { src = "https://github.com/sschleemilch/slimline.nvim" },
  { src = "https://github.com/gbprod/substitute.nvim" },
  { src = "https://github.com/chentoast/marks.nvim" },
  {
    src = "https://github.com/nvim-mini/mini.surround",
    version = "main",
  },
  {
    src = "https://github.com/nvim-mini/mini.ai",
    version = "main",
  },
  { src = "https://github.com/Wansmer/treesj" },
  { src = "https://github.com/mfussenegger/nvim-lint" },
  { src = "https://github.com/nvim-neotest/neotest" },
  { src = "https://github.com/nvim-neotest/neotest-python" },
  { src = "https://github.com/jfpedroza/neotest-elixir" },
  { src = "https://github.com/stevearc/aerial.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
  { src = "https://github.com/b0o/SchemaStore.nvim" },
  { src = "https://github.com/folke/persistence.nvim" },
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  {
    src = "https://github.com/nickjvandyke/opencode.nvim",
    version = vim.version.range("*"),
  },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  { src = "https://github.com/danymat/neogen" },
})
