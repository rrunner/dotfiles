-- byte-compile and cache lua files/modules
vim.loader.enable()

-- use exploratory UI
require("vim._core.ui2").enable({})

-- define global configuration table
_G.Config = {}

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
