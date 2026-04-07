-- byte-compile and cache lua files
vim.loader.enable()

-- define global configuration table
_G.Config = {}

-- use new exploratory UI
require("vim._core.ui2").enable({})
