#
# ~/.bash_profile
#

# extend PATH for my user
export PATH="${PATH}:$HOME/bin"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

export PYENV_VIRTUALENV_DISABLE_PROMPT=1

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

[[ -f ~/.bashrc ]] && . ~/.bashrc
