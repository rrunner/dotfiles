-- byte-compile and cache lua files/modules
vim.loader.enable()

-- define global configuration table
_G.Config = {}

-- use exploratory UI
require("vim._core.ui2").enable({})

require("global_variables")
require("plugins")
require("utils")
require("icons")
require("options")
require("autocommands")
require("usercommands")
require("filetypes")
require("keymaps")
require("lsp")
