-- byte-compile and cache lua files
vim.loader.enable()

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end
vim.o.rtp = lazypath .. "," .. vim.o.rtp

require("config.options")
require("config.autocmds")
require("config.usercmds")
require("config.filetype")
require("config.keymaps")
require("lsp")

-- initialize lazy.nvim
require("lazy").setup("plugins", {
  ui = {
    size = { width = 0.8, height = 0.9 },
    border = "none",
    backdrop = 100,
    custom_keys = {
      -- reset default mappings (preset with the plugin)
      ["<localleader>l"] = false,
      ["<localleader>i"] = false,
      ["<localleader>t"] = false,
    },
  },
  install = {
    missing = true,
  },
  checker = {
    enabled = vim.g.is_github_not_blocked,
    notify = false,
  },
  change_detection = {
    enabled = vim.g.is_github_not_blocked,
    notify = false,
  },
  performance = {
    rtp = {
      paths = { vim.fn.stdpath("data") .. "/site/" },
      disabled_plugins = {
        "gzip",
        "matchit",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  rocks = {
    enabled = false,
  },
})

-- use "o" to toggle menu items in lazy.nvim
require("lazy.view.config").keys.details = "o"
