-- byte-compile and cache lua files/modules
vim.loader.enable()

-- define global configuration table
_G.Config = {}

-- use exploratory UI
require("vim._core.ui2").enable({})

-- use built-in plugins
vim.cmd.packadd("nvim.undotree") -- :Undotree
vim.cmd.packadd("nvim.difftool") -- :Difftool <folder1|file1> <folder2|file2>
