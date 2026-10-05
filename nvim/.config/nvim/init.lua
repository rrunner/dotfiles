-- byte-compile and cache lua files/modules
vim.loader.enable()

-- define global configuration table
_G.Config = {}

-- use exploratory UI
require("vim._core.ui2").enable({})

-- core configuration
require("config.globals")
require("config.vimpack")
require("config.utils")
require("config.icons")
require("config.options")
require("config.autocommands")
require("config.usercommands")
require("config.filetypes")
require("config.keymaps")
require("config.lsp")

-- core plugins (ordered/managed execution order)
require("plugins.colorscheme")
require("plugins.treesitter")
require("plugins.icons")
