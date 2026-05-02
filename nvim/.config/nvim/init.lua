-- byte-compile and cache lua files/modules
vim.loader.enable()

-- define global configuration table
_G.Config = {}

-- use exploratory UI
require("vim._core.ui2").enable({})

-- core configuration
require("globals")
require("vimpack")
require("utils")
require("icons")
require("options")
require("autocommands")
require("usercommands")
require("filetypes")
require("keymaps")
require("lsp")

-- core plugins (ordered/managed execution order)
require("plugins.colorscheme")
require("plugins.treesitter")
require("plugins.icons")
