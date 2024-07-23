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
vim.opt.rtp:prepend(lazypath)

-- set leader key
vim.api.nvim_set_keymap("n", "<space>", "<nop>", {
  silent = true,
  desc = "The space key should only act as the leader key",
})

vim.api.nvim_set_keymap("v", "<space>", "<nop>", {
  silent = true,
  desc = "The space key should only act as the leader key",
})

vim.g.mapleader = " "

-- set localleader key
vim.api.nvim_set_keymap("n", "-", "<nop>", {
  silent = true,
  desc = "The minus (-) sign should only act as the localleader key",
})

vim.api.nvim_set_keymap("v", "-", "<nop>", {
  silent = true,
  desc = "The minus (-) sign should only act as the localleader key",
})

vim.g.maplocalleader = "-"

-- setting required by many plugins
vim.opt.termguicolors = true

require("config.icons")
require("config.autocmds")
require("config.usercmds")
require("config.filetype")
require("config.abbreviations")
require("config.keymaps")
require("config.options")
require("config.lsp")

-- initialize lazy.nvim
require("lazy").setup("plugins", {
  ui = {
    custom_keys = {
      -- reset default mappings (preset with the plugin)
      ["<localleader>l"] = false,
      ["<localleader>t"] = false,
    },
  },
  install = {
    missing = true,
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
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
