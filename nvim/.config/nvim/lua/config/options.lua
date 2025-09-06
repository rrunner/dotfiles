-- options
local utils = require("config.utils")
local icons = require("config.icons")

-- global variables
-- manually set is_github_blocked to true if site prevents github usage
vim.g.is_github_blocked = false
vim.g.is_github_not_blocked = not vim.g.is_github_blocked
vim.g.editorconfig = true
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
-- force selection of clipboard tool (xclip works both in linux and in WSL)
vim.g.clipboard = "xclip"
-- pyproject.toml and uv.lock has equal priority in deciding the root directory (e.g. parent folder)
vim.g.py_root_markers = {
  { "pyproject.toml", "uv.lock" },
  "requirements.txt",
  "Pipfile",
}

vim.cmd([[
  syntax off
  filetype plugin indent on
]])
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg -H --no-heading --vimgrep --smart-case --follow"
end
vim.opt.compatible = false
vim.opt.grepformat:append({ "$f:$l:%c:%m" })
vim.opt.autoindent = true
vim.opt.smartindent = false -- set to false if using treesitter
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.encoding = "utf-8"
vim.opt.fileformat = "unix"
vim.opt.fileencoding = "utf-8"
vim.opt.infercase = true
vim.opt.wrap = false
vim.opt.errorbells = false
vim.opt.ruler = false
vim.opt.laststatus = 3
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.title = true
vim.opt.background = "dark"
vim.opt.cursorline = true
vim.opt.cursorlineopt = "both" --line and number
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.shortmess:append({ I = true, c = true, W = true })
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.showmatch = false
vim.opt.matchtime = 2 -- only used when showmatch = true
vim.opt.cmdheight = 1
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.formatoptions:append({ "q", "j" })
vim.opt.formatoptions:remove({ "c", "r", "o" })
vim.opt.ttyfast = true
vim.opt.lazyredraw = true
vim.opt.autoread = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 3
vim.opt.signcolumn = "yes:3"
vim.opt.numberwidth = 4
vim.opt.hidden = true
vim.opt.magic = true
vim.opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- only set clipboard if not in ssh, to make sure the OSC 52 integration works automatically
vim.opt.nrformats:append({ "alpha" })
vim.opt.list = true
vim.opt.listchars = { tab = ">·", trail = "·", nbsp = "+" }
vim.opt.updatetime = 300
vim.opt.viewdir = vim.fn.stdpath("data") .. "/view"
vim.opt.viewoptions:append({ localoptions = true })
vim.opt.sessionoptions:append({ "localoptions", "winpos" })
vim.opt.sessionoptions:remove({ "blank" })
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undolevels = 10000
vim.opt.timeout = true
vim.opt.timeoutlen = 1000
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 50
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.breakindent = true
vim.opt.mouse = "a"
vim.opt.inccommand = "split"
vim.opt.cmdwinheight = 20 -- when inccommand = "split"
vim.opt.shell = "bash"
vim.opt.splitkeep = "topline"
vim.opt.pumheight = 15
vim.opt.spellsuggest = "best,10"
vim.opt.wildmenu = true
vim.opt.wildignore = {
  "*.pyc",
  "*.swp",
  "*.aux",
  "*.out",
  "*.toc",
  "*.exe",
  "*.dll",
  "*.bmp",
  "*.gif",
  "*.jpg",
  "*.jpeg",
  "*.png",
  "*.avi",
  "*.mov",
  "*.mpg",
  "*.mpeg",
  "*.mp3",
  "*.mp4",
  "*.oga",
  "*.ogg",
  "*.wav",
  "*.flac",
  "*.otf",
  "*.ttf",
  "*.doc",
  "*.pdf",
  "*.zip",
  "*.tar",
  "*.rar",
}
vim.opt.wildmode = { "longest:full", "full" }
vim.opt.winminwidth = 5
vim.opt.virtualedit = "block"
vim.opt.smoothscroll = true
vim.opt.jumpoptions = "view"
vim.opt.conceallevel = 2 -- hide * markup for bold and italic, but not markers with substitutions
vim.opt.diffopt = "internal,filler,closeoff,algorithm:patience,linematch:60"
vim.o.guicursor = "n-v-sm:block-nCursor,i-c-ci-ve:ver25-iCursor,r-cr-o:hor20,t:block-blinkon0-blinkoff0-TermCursor"
vim.opt.iskeyword:append("-")
vim.opt.synmaxcol = 300
-- vim.opt.winborder = "rounded"
vim.opt.fillchars = {
  diff = icons.chars.diff,
  eob = " ",
  fold = " ",
  foldclose = icons.chars.foldclose,
  foldopen = icons.chars.foldopen,
  foldsep = " ",
}
vim.wo.foldenable = true
vim.wo.foldlevel = 99 -- open buffers unfolded
vim.wo.foldmethod = "expr"
vim.wo.foldtext = ""

-- windows specific
if utils.IS_WIN then
  vim.opt.shell = "pwsh"
  vim.opt.shellcmdflag =
    "-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';$PSStyle.OutputRendering='plaintext';Remove-Alias -Force -ErrorAction SilentlyContinue tee;"
  vim.opt.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
  vim.opt.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
  vim.opt.shellslash = true
end

-- wsl specific
if utils.IS_WSL then
  -- use WSL at work with editorconfig (see https://github.com/neovim/neovim/issues/21648)
  require("editorconfig").properties.insert_final_newline = nil
  vim.opt.endofline = false
end
