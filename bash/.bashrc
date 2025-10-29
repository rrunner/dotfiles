#
# ~/.bashrc
#

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# configure bash to mark the start of each prompt
PROMPT_COMMAND='printf "\033]133;A\007"'

# check WSL
IS_WSL=0
if [[ $(grep -iq microsoft /proc/version) ]]; then
  IS_WSL=1
fi

# history related
export HISTCONTROL=ignoredups:erasedups # no duplicate entries
export HISTSIZE=100000                  # big history
export HISTFILESIZE=100000              # big history
shopt -s histappend                     # append to history, do not overwrite

# save and reload the history after each command finishes
# export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# manpager
# `gO` to list man sections in quickfix list
export MANPAGER="nvim +Man!"

# bind up/down key to search the history; useful for cmd args: nvim <up>/<down>
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# check window size after each cmd and if necessary update LINES/COLUMNS
# shopt -s checkwinsize

# source environment variables
if [[ -f "$HOME/.env" ]]; then
  source "$HOME/.env" 2>/dev/null || true
fi

alias ls="ls --color=auto"
alias ll="ls -la --color=auto"
alias q="exit"
alias cls="clear"
alias cd..="cd .."
alias gs="git status"
alias ga="git add"
alias gd="git diff"
alias gdc="git diff --cached"
alias gc="git commit -m"
alias gl="git log"
alias ds="dotfiles status"
alias activate="source .venv/bin/activate 2>/dev/null || source venv/bin/activate 2>/dev/null || echo 'No virtual environment for Python available'"

PS1='[\u@\h \W]\$ '
#LANG="sv_SE.UTF-8"

# force Alacritty to use software rendering
if [ $IS_WSL -eq 0 ]; then
  export LIBGL_ALWAYS_SOFTWARE=1
fi

# vi mode
# - used to cause conflicts in tmux mode
# - also update .inputrc if vi mode should be turned on
# set -o vi

# dotfiles
if [ $IS_WSL -eq 0 ]; then
  alias dotfiles='/usr/bin/git --git-dir=$HOME/Dropbox/dotfiles --work-tree=$HOME'
fi

# to view manual pages in browser (for example 'man -H man')
export BROWSER=firefox

# default editor
export EDITOR=nvim
export VISUAL=nvim

# R language
export R_ENVIRON_USER=~/.config/r/.Renviron
export R_PROFILE_USER=~/.config/r/.Rprofile

# go
# export GOPATH=~/projects/go
# export PATH=$PATH:$GOPATH/bin

# completion for git
source /usr/share/git/completion/git-completion.bash

# completion for cht.sh
source "$HOME"/.bash.d/cht.sh

# fzf for fuzzy completion and keybindings (ctrl-t, ctrl-r and alt-c) in bash
#  - ** is the prefix
source /usr/share/fzf/completion.bash
source /usr/share/fzf/key-bindings.bash

# bash completion (install bash-completion package)
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

# ripgrep configuration file is set via environment variable
export RIPGREP_CONFIG_PATH="$HOME"/.config/ripgrep/ripgreprc

# use ripgrep as default command to fzf (with bat as previewer)
# - use git ls-files command inside git repo
# - use ripgrep to search files (ctrl-t)
if type rg &>/dev/null; then
  RG_OPTIONS="--files --smart-case --follow --hidden --no-messages"
  export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard || rg $RG_OPTIONS"
  export FZF_DEFAULT_OPTS="--no-mouse --height 80% -1 --reverse --multi --inline-info --scroll-off=3 --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='down,60%:wrap:hidden' --bind='?:toggle-preview,ctrl-p:up,ctrl-n:down,ctrl-d:preview-down,ctrl-f:preview-up,ctrl-y:accept,ctrl-q:ignore'"
  export FZF_CTRL_T_COMMAND="rg $RG_OPTIONS"
fi

# use fd to search folders (alt-c)
# - fd uses smart-case by default
if type fd &>/dev/null; then
  FD_OPTIONS="--follow --hidden --exclude .git"
  # export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
  export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
fi

# force tmux to assume that the terminal support 256 colors
alias tmux="tmux -2"
export TERM="xterm-256color"

if [ -z "${DISPLAY}" ] && [ "$(tty)" = "/dev/tty1" ]; then
  #exec startx
  exec startx >/dev/null 2>&1
fi

# directory under ~/.config/ where neovim looks for config files (default is "nvim")
export NVIM_APPNAME="nvim"

# debug python from terminal
export DEBUG_PYTHON="0"

# uv (uses HTTP_PROXY, HTTPS_PROXY, ALL_PROXY)
export UV_DEFAULT_INDEX="https://pypi.org/simple"
eval "$(uv generate-shell-completion bash)"
eval "$(uvx --generate-shell-completion bash)"
export PATH="${HOME}/.local/bin:$PATH" # tool executables

# starship prompt
eval "$(starship init bash)"

# direnv (project based environment variables set in .envrc)
eval "$(direnv hook bash)"

# zoxide
eval "$(zoxide init bash)"
