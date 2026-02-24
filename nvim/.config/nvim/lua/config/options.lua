-- options
local utils = require("config.utils")
local icons = require("config.icons")

-- global variables
vim.g.mapleader = " "
vim.g.maplocalleader = "-"
vim.g.is_github_blocked = false -- block github usage
vim.g.is_github_not_blocked = not vim.g.is_github_blocked
vim.g.editorconfig = true
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
-- select clipboard tool (xclip works both in linux and in WSL)
vim.schedule(function()
  vim.g.clipboard = "xclip"
end)
vim.g.py_root_markers = { { "pyproject.toml", "uv.lock" }, "requirements.txt", "Pipfile" } -- set root directory (e.g. parent folder)

vim.cmd("filetype plugin indent on")
if vim.fn.exists("syntax_on") ~= 1 then
  vim.cmd("syntax enable")
end
if vim.fn.executable("rg") == 1 then
  vim.o.grepprg = "rg -H --no-heading --vimgrep --smart-case --follow"
end
vim.o.scrollback = 10000
vim.o.compatible = false
vim.o.grepformat = "%f:%l:%c:%m,$f:$l:%c:%m"
vim.o.autoindent = true
vim.o.smartindent = false -- set to false if using treesitter
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftround = true
vim.o.shiftwidth = 2
vim.o.encoding = "utf-8"
vim.o.fileformat = "unix"
vim.o.fileencoding = "utf-8"
vim.o.infercase = true
vim.o.wrap = false
vim.o.errorbells = false
vim.o.ruler = false
vim.o.laststatus = 3
vim.o.number = true
vim.o.relativenumber = true
vim.o.title = true
vim.o.background = "dark"
vim.o.cursorline = true
vim.o.cursorlineopt = "both" --line and number
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.shortmess = "CFOISWaco"
vim.o.showcmd = false
vim.o.showmode = false
vim.o.showmatch = false
vim.o.matchtime = 2 -- only used when showmatch = true
vim.o.cmdheight = 1
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.backspace = "indent,eol,start"
vim.o.formatoptions = "rqnl1jt"
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
vim.o.ttyfast = true
vim.o.lazyredraw = false
vim.o.autoread = true
vim.o.autowrite = false
vim.o.autochdir = false
vim.o.scrolloff = 8
vim.o.sidescrolloff = 3
vim.o.signcolumn = "yes:3"
vim.o.numberwidth = 4
vim.o.hidden = true
vim.o.magic = true
vim.o.selection = "inclusive"
vim.o.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- only set clipboard if not in ssh, to make sure the OSC 52 integration works automatically
vim.o.nrformats = "bin,hex,alpha"
vim.o.list = true
vim.o.listchars = "tab:> ,trail:·,nbsp:+,extends:…,precedes:…,"
vim.o.updatetime = 300
vim.o.viewdir = vim.fn.stdpath("data") .. "/view"
vim.o.viewoptions = "folds,cursor,curdir,localoptions"
vim.o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,terminal,localoptions,winpos"
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.undofile = true
local undodir = vim.fn.stdpath("data") .. "/undodir"
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
vim.o.undodir = undodir
vim.o.undolevels = 10000
vim.o.timeout = true
vim.o.timeoutlen = 1000
vim.o.ttimeout = true
vim.o.ttimeoutlen = 50
vim.o.completeopt = "menuone,noselect,fuzzy"
vim.o.breakindent = true
vim.o.mouse = "a"
vim.o.inccommand = "split"
vim.o.cmdwinheight = 20 -- when inccommand = "split"
vim.o.shell = "bash"
vim.o.splitkeep = "topline"
vim.o.pumheight = 10
vim.o.pumblend = 10
vim.o.spellsuggest = "best,10"
vim.o.wildmenu = true
vim.o.wildignore =
  "*.pyc,*.swp,*.aux,*.out,*.toc,*.exe,*.dll,*.bmp,*.gif,*.jpg,*.jpeg,*.png,*.avi,*.mov,*.mpg,*.mpeg,*.mp3,*.mp4,*.oga,*.ogg,*.wav,*.flac,*.otf,*.ttf,*.doc,*.pdf,*.zip,*.tar,*.rar"
vim.o.wildmode = "longest:full,full"
vim.o.winminwidth = 5
vim.o.virtualedit = "block"
vim.o.smoothscroll = true
vim.o.jumpoptions = "view"
vim.o.conceallevel = 2 -- hide * markup for bold and italic, but not markers with substitutions
vim.o.diffopt = "internal,filler,closeoff,algorithm:patience,linematch:60"
vim.o.guicursor = "n-v-sm:block-nCursor,i-c-ci-ve:ver25-iCursor,r-cr-o:hor20,t:block-blinkon0-blinkoff0-TermCursor"
vim.o.iskeyword = "@,48-57,_,192-255,-"
vim.o.synmaxcol = 300
vim.o.redrawtime = 10000 -- increase neovim redraw tolerance
vim.o.maxmempattern = 20000 -- increase max memory
vim.o.winborder = "rounded"
vim.o.fillchars = "diff:"
  .. icons.chars.diff
  .. ",eob: ,fold: "
  .. ",foldclose:"
  .. icons.chars.foldclose
  .. ",foldopen:"
  .. icons.chars.foldopen
  .. ",foldsep: "
vim.o.foldenable = true
vim.o.foldlevel = 99 -- open buffers unfolded
vim.o.foldmethod = "expr"
vim.o.foldtext = ""
vim.o.exrc = true -- add .nvim.lua to project root for project specific configuration
vim.o.secure = true -- must accept .nvim.lua files before parsing

-- windows specific (these options may be obsolete)
if utils.IS_WIN then
  vim.o.shell = "pwsh"
  vim.o.shellcmdflag =
    "-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';$PSStyle.OutputRendering='plaintext';Remove-Alias -Force -ErrorAction SilentlyContinue tee;"
  vim.o.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
  vim.o.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
  vim.o.shellslash = true

  -- start terminal: must hardcode terminal shell on windows to get pwsh
  -- consider update keymap to <c-;>, and make it toggle
  local term_str = "<cmd>belowright split term://pwsh | resize -10<cr>i"
  vim.keymap.set("n", "<leader>t", term_str, {
    noremap = true,
    desc = "Start a terminal buffer in terminal mode",
  })
end

-- wsl specific (these options may be obsolete)
if utils.IS_WSL then
  -- use WSL at work with editorconfig (see https://github.com/neovim/neovim/issues/21648)
  require("editorconfig").properties.insert_final_newline = nil
  vim.o.endofline = false
end
