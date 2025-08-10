" autocommand settings {{{
augroup vimrc
  " remove autocommands for the group
  autocmd!

  " autoformat json files when saving (requires jq on system)
  autocmd BufWritePre *.json %!jq

  " avoid persistent undos for temporary files
  autocmd BufWritePre /tmp/* setlocal noundofile

  " exit Vim if NERDTree is the only window remaining in the only tab.
  autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

  " close the tab if NERDTree is the only window remaining in it.
  autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

  " settings applied to a new terminal
  autocmd TerminalWinOpen * setlocal nonumber norelativenumber signcolumn="no"

  " close help with q
  autocmd FileType help nnoremap <buffer><silent> q :close<cr>

  " close command line window (q:, q/ and q? etc.) with "q"
  autocmd Cmdwinenter * nnoremap <buffer><silent> q :close<cr>

  " make autoread work as expected on Windows OS (not tested on Windows OS with vim)
  if has("win32")
    " auto-reload files when modified externally
    autocmd BufEnter,CursorHold,CursorHoldI,FocusGained * if mode() != 'c' | checktime | endif
  endif

  " resize splits when terminal is resized
  autocmd VimResized * wincmd =

    " set filetype for *.mail
    autocmd BufRead,BufNewFile *.mail set filetype=mail

  " open file at the last edited position (for configuration files)
  autocmd BufReadPost *.toml,*.yaml,*.yml,*.json,*.jsonc silent! normal! g`"zv

  " only use number in insert mode (not relativenumber) if number option is set
  autocmd InsertEnter * if &number == 1 | setlocal number norelativenumber | endif
  autocmd InsertLeave * if &number == 1 | setlocal number relativenumber | endif
augroup end
" }}}


" usercmd settings {{{

" change pwd/cwd to the location of the current file's directory
command -nargs=0 Cwd call Cwd()
function Cwd()
  cd %:p:h
  pwd
endfunction

" }}}


" tmux settings {{{
if exists('$TMUX')
  " cursor in tmux sessions
  let &t_SI = "\<Esc>Ptmux;\<Esc>\e[6 q\<Esc>\\"
  let &t_SR = "\<Esc>Ptmux;\<Esc>\e[4 q\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
endif
" }}}


" vim settings (not tmux) {{{
if !has("gui_running") && !exists('$TMUX')
  " cursor in vim sessions (no dedicated command-line cursor, inherits normal mode)
  let &t_SI="\<Esc>[6 q"
  let &t_SR="\<Esc>[4 q"
  let &t_EI="\<Esc>[2 q"
endif
" }}}


" vim settings {{{
if !has("gui_running")
  " enable alt/meta key in vim
  map <esc>h <m-h>
  map <esc>j <m-j>
  map <esc>k <m-k>
  map <esc>l <m-l>
endif
" }}}


" load plugins {{{

" vim plugin to enable editorconfig
packadd! editorconfig

" plugins via plugin manager
call plug#begin('~/.vim/pack')
  Plug 'vim-pandoc/vim-pandoc-syntax'
  Plug 'quarto-dev/quarto-vim'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'lervag/vimtex', { 'for': ['tex', 'latex'] }
  Plug 'inkarkat/vim-ReplaceWithRegister'
  Plug 'kana/vim-textobj-user'
  Plug 'kana/vim-textobj-indent'
  Plug 'kana/vim-textobj-line'
  Plug 'bps/vim-textobj-python'
  Plug 'itchyny/lightline.vim'
  " Plug 'doums/darcula'
  Plug 'nordtheme/vim'
  " requires fzf to be installed on system
  "  - requires 'ripgrep' for grep and text searches inside files
  "  - 'bat' tool for preview fzf results is optional
  Plug 'junegunn/fzf.vim'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'christoomey/vim-tmux-runner'
  Plug 'tommcdo/vim-exchange'
  Plug 'kshenoy/vim-signature'
  Plug 'vim-test/vim-test'
  " requires python-doq to be installed on system
  " Plug 'heavenshell/vim-pydocstring', { 'for': 'python' }
  Plug 'Vimjas/vim-python-pep8-indent', { 'for': 'python' }
  Plug 'jiangmiao/auto-pairs'
  Plug 'machakann/vim-highlightedyank'
  Plug 'preservim/nerdtree'
  " requires nerdfonts to be installed on system
  Plug 'ryanoasis/vim-devicons'
  Plug 'chrisbra/improvedft'
call plug#end()
" }}}


" plugin settings: netrw {{{
let g:netrw_altv = 1
let g:netrw_dirhistmax = 0
let g:netrw_liststyle = 3
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_browse_split = 4
" }}}


" plugin settings: vim-ReplaceWithRegister {{{
nmap cr <Plug>ReplaceWithRegisterOperator
nmap crr <Plug>ReplaceWithRegisterLine
xmap cr <Plug>ReplaceWithRegisterVisual
" }}}


" plugin settings: vim-tmux-runner {{{
" see also .vim/after/ftplugin/*.vim
let g:VtrPercentage = 25
let g:VtrOrientation = "h"
let g:VtrInitialCommand = "pwd"
" }}}


" plugin settings: vim-test {{{
let test#strategy = "make"
let test#python#runner = 'pyunit'
" }}}


" plugin settings: vim-pydocstring {{{
" let g:pydocstring_doq_path = "/usr/bin/doq"
" let g:pydocstring_formatter = 'google'
" let g:pydocstring_ignore_init = 1
" let g:pydocstring_enable_mapping = 0
" }}}


" plugin settings: vim-python-pep8-indent {{{
let g:python_pep8_indent_multiline_string = 0
let g:python_pep8_indent_hang_closing = 0
" }}}


" plugin settings: vimtex {{{
let g:vimtex_view_general_viewer = 'xpdf'
let g:vimtex_mappings_enabled=0
" }}}


" plugin settings: autopairs {{{
let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsShortcutFastWrap = '<M-l>'
let g:AutoPairsShortcutJump = '<M-n>'
let g:AutoPairsShortcutBackInsert = '<M-h>'
let g:AutoPairsCenterLine = 0
" }}}


" plugin settings: vim-highlightedyank {{{
let g:highlightedyank_highlight_duration = 700
let g:highlightedyank_highlight_in_visual = 0
" }}}


" plugin settings: nerdtree {{{
let g:NERDTreeShowHidden = 1
let g:NERDTreeSortHiddenFirst = 1
let g:NERDTreeMapOpenSplit = 'x'
let g:NERDTreeMapOpenVSplit = 'v'
" }}}


" plugin settings: fzf.vim {{{
" - stop fzf searches in terminal mode with <c-q>
let g:fzf_buffers_jump = 1
let g:fzf_layout = {'down': '40%'}
let g:fzf_action = {
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

command! -bang -nargs=* MyRg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview('up:60%:hidden:wrap', '?'), <bang>0)
" }}}


" plugin settings: improvedft  {{{
let g:ft_improved_ignorecase = 1
let g:ft_improved_multichars = 0
let g:ft_improved_nohighlight = 1
" }}}


" leader mappings {{{

" space should only act as leader key in normal and visual mode
nmap <space> <nop>
vmap <space> <nop>
let mapleader=' '

" nnoremap <leader>t :below terminal<cr>
nnoremap <leader>ex :NERDTree<cr>
" nnoremap <leader>ex :Lexplore<cr>
nnoremap <leader>w :up<cr>
nnoremap <leader>sub :%s///gc<left><left><left><left>
nnoremap <leader>gl :g//<left>
nnoremap <leader>ef :e <c-r>=expand("%:p:h")."/"<cr>
nnoremap <leader>eh :split <c-r>=expand("%:p:h")."/"<cr>
nnoremap <leader>ev :vsplit <c-r>=expand("%:p:h")."/"<cr>
nnoremap <leader>en :vnew<cr>
nnoremap <leader>co :copen<cr>
nnoremap <leader>cc :cclose<cr>
nnoremap <silent> <leader>sb :Buffers<cr>
nnoremap <silent> <leader>sf :Files<cr>
nnoremap <silent> <leader>sg :MyRg<cr>
nnoremap <silent> <leader>sl :Lines<cr>
" nnoremap <silent> <leader>j }
" nnoremap <silent> <leader>j :m .+1<cr>==
" nnoremap <silent> <leader>k {
" nnoremap <silent> <leader>k :m .-2<cr>==
vnoremap <leader>eb64 c<c-r>=system('base64', @")<cr><esc>
vnoremap <leader>db64 c<c-r>=system('base64 --decode', @")<cr><esc>
" yank to clipboard register
noremap <leader>y "+y
" paste from clipboard register
noremap <leader>p "+p
" yank without trailing blanks (block visual mode)
xnoremap y zy
" paste a block of text without trailing blanks
nnoremap p zp
" paste a block of text before cursor without trailing blanks
nnoremap P zP
" }}}


" localleader mappings {{{

" - should only act as localleader key in normal and visual mode
nmap - <nop>
vmap - <nop>
let maplocalleader='-'

" VTR mappings
nnoremap <localleader>r :VtrSendLinesToRunner<cr>j
vnoremap <localleader>r :VtrSendLinesToRunner<cr><esc>gvj<esc>
nnoremap <localleader>kr :VtrKillRunner<cr>
nnoremap <localleader>or :VtrOpenRunner {'cmd': 'ipython\ --no-autoindent\ --pprint'}<cr>
nnoremap <localleader>cl :VtrSendKeysRaw 'c-l'<cr>
" vim-test mappings
nnoremap <localleader>tn :TestNearest<cr>
nnoremap <localleader>tf :TestFile<cr>
nnoremap <localleader>ts :TestSuite<cr>
nnoremap <localleader>tl :TestLast<cr>
nnoremap <localleader>tv :TestVisit<cr>
" vim-pydocstring mappings
nnoremap <localleader>ds :Pydocstring<cr>
" vimtex mappings
nnoremap <localleader>ll <plug>(vimtex-compile)<cr>
" compile
nnoremap <localleader><c-enter> :make<cr>
" }}}


" mappings {{{

" directional mappings
nnoremap <silent> H ^
nnoremap <silent> L g_
nnoremap <silent> M %

" search only in visual selected text
xnoremap / <esc>/\%V

" U to redo
nnoremap U <c-r>

" note: use ":" to fetch visual selection to command-line mode in visual mode

" esc to enter command-line mode
nnoremap <esc> :

" remove highlight search result
nnoremap <silent> <c-t> :<c-u>nohlsearch<cr>

" yank from cursor to end of line (exclude linefeed char)
nnoremap Y yg_

" enter Normal mode by pressing jj in insert mode
" inoremap jj <esc>

" moving text
" vnoremap J :m '>+1<cr>gv=gv
" vnoremap K :m '<-2<cr>gv=gv

" reselect visual selection after indenting
vnoremap < <gv
vnoremap > >gv

" when text is wrapped, move up/down by visual line (e.g. not by vim line),
" unless a count is provided
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" resize current window by +/- 1
nnoremap <m-h> :vertical resize +1<cr>
nnoremap <m-l> :vertical resize -1<cr>
nnoremap <m-j> :resize +1<cr>
nnoremap <m-k> :resize -1<cr>

" cycle buffers, items in quickfix list, and tabs
nnoremap [s [szz
nnoremap ]s ]szz
nnoremap [b :bprevious<cr>
nnoremap ]b :bnext<cr>
nnoremap [q :cprevious<cr>
nnoremap ]q :cnext<cr>
nnoremap ]t :tabnext<cr>
nnoremap [t :tabprevious<cr>

" disable arrow keys in normal/visual mode
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <right> <nop>
nnoremap <left> <nop>
vnoremap <up> <nop>
vnoremap <down> <nop>
vnoremap <right> <nop>
vnoremap <left> <nop>

" send escape character in a terminal mode to enter normal mode
" - stop fzf searches in terminal mode with <c-q>
" - kill terminal session with <c-d> in terminal mode
"   (using q in normal mode does not kill the terminal process)
tnoremap <expr><esc> "<c-\><c-n>"

" expand %% to the path of the current buffer
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" display search results at center of screen
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zzN
nnoremap # #zzN
nnoremap <c-u> <c-u>M
nnoremap <c-d> <c-d>M

" <leader><leader> toggles between active buffer and alternate buffer
nnoremap <leader><leader> <c-^>

" delete buffer (after switching to alternate buffer)
nnoremap <silent><leader>bd :lclose<bar>b#<bar>bd! #<cr>

" fix buffer to window (toggle command)
nnoremap <silent><leader>bf :setlocal winfixbuf!<cr>

" replace << with = in insert mode
inoremap << =

" move left in insert mode (left arrow)
inoremap <c-b> <left>

" move right in insert/command-line mode (right arrow)
inoremap <c-l> <right>
cnoremap <c-l> <right>

" move right in insert mode (right arrow)
inoremap <c-f> <right>

" delete line but do not write to yank register
nnoremap <leader>DD ""dd

" yank/paste the current line and then comment the same line
nmap ycc yygccp

" keybinds below is an attempt to align with readline
cnoremap <c-b> <left>
cnoremap <c-f> <right>
cnoremap <c-d> <nop>
cnoremap <c-a> <home>
cnoremap <c-e> <end>
" }}}


" abbreviations {{{
iabbrev teh the
iabbrev adn and
iabbrev sytem system
" }}}


" options {{{
set nocompatible
set shell=/bin/bash
syntax enable
filetype plugin on
filetype indent on
set termguicolors
" colorscheme darcula, lightline below \ 'colorscheme': 'darculaOriginal',
colorscheme nord
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified',
      \               'fugstatus' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype'] ]},
      \}
" the grep program requires ripgrep
if executable('rg')
    set grepprg=rg\ -H\ --no-heading\ --vimgrep\ --smart-case\ --follow
endif
set grepformat+=$f:$l:%c:%m
set autoindent smartindent smarttab expandtab
set tabstop=2 softtabstop=2
set shiftround
set shiftwidth=2
set encoding=utf-8
set fileformat=unix
set fileencoding=utf-8
set wildmenu
set wildignore=*.pyc,*.swp,*.png,*.jpg,*.aux,*.out,*.toc,*.exe,*.dll,*.bmp,*.gif,*.jpeg,*.avi,*.mov,*.mpg,*.mpeg,*.mp3,*.mp4,*.oga,*.ogg,*.wav,*.flac,*.otf,*.ttf,*.doc,*.pdf,*.zip,*.tar,*.rar
set wildmode=longest:full,full
set infercase
set nowrap
set noerrorbells
set noruler
set laststatus=2
set number relativenumber
set title
set background=dark
" set colorcolumn=81
set cursorline
set splitbelow
set splitright
set shortmess=I
set shortmess+=c
set shortmess+=W
set noshowcmd
set noshowmode
set noshowmatch
set matchtime=2 " only used for 'set showmatch'
set cmdheight=2
set nohlsearch incsearch ignorecase smartcase
set backspace=indent,eol,start
set spell spelllang=en,sv
set formatoptions-=c
set formatoptions-=r
set formatoptions-=o
set formatoptions+=j
set formatoptions+=q
set ttyfast
set lazyredraw
set autoread
set scrolloff=8
set sidescrolloff=3
set signcolumn="yes"
set numberwidth=4
set hidden
set magic
set clipboard^=unnamed,unnamedplus
set nrformats+=alpha
set list listchars=tab:>·,trail:·,nbsp:+
set updatetime=300
set viewdir=$HOME/.vim/view
set viewoptions+=localoptions
set sessionoptions-=terminal
set sessionoptions+=localoptions
set nobackup
set nowritebackup
set noswapfile
set undofile
set undodir=$HOME/.vim/undodir
set undolevels=10000
set timeout timeoutlen=1000 ttimeout ttimeoutlen=50
set completeopt=menu,menuone,noselect
set breakindent
set mouse=a
set ttymouse=sgr
set fillchars=foldopen:-,foldclose:+,fold:\ ,foldsep:\ ,diff:/,eob:\ ,
set foldenable
set foldlevel=99
set foldmethod=manual
set foldnestmax=5
set spelloptions=camel
set smoothscroll
set spellsuggest=best,10
set pumheight=15
set winminwidth=5
set virtualedit=block
set diffopt=internal,filler,closeoff,algorithm:patience,linematch:60
set iskeyword+=-
set synmaxcol=300

" windows os specific settings
if has("win32")
  set shell = "pwsh"
  set shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';"
  set shellredir = '2>&1 | %{ "$_" } | Out-File %s; exit $LastExitCode'
  set shellpipe = '2>&1 | %{ "$_" } | Tee-Object %s; exit $LastExitCode'
  set shellquote = ""
  set shellxquote = ""
  set shellslash
endif
" }}}


" gvim options  {{{
if has("gui_running")
  "set linespace=0
  set guioptions+=k
  set guioptions-=L
  set guioptions-=l
  set guioptions-=T
  set guioptions-=m
  set guioptions+=!
  set guifont=JetBrains\ Mono\ 11
  " highlight ColorColumn ctermbg=0 guibg=lightgrey
  set guicursor+=c-ci-cr:ver25-iCursor " beam cursor in command-line mode
  set guicursor+=a:blinkon0
  highlight iCursor guifg=#2E3440 guibg=#D8DEE9
  highlight Cursor guifg=#2E3440 guibg=#D8DEE9
endif
" }}}


" vim: filetype=vim foldmethod=marker
