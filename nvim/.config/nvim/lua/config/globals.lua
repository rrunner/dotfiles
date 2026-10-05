-- global variables
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
