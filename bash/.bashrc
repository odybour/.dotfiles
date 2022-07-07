#
# ~/.bashrc
#

unset LANG
source /etc/profile.d/locale.sh

if [[ $DISPLAY ]]; then
    # If not running interactively, do not do anything
    [[ $- != *i* ]] && return
    [[ -z "$TMUX" ]] && exec tmux
fi

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

set -o vi

export EDITOR=nvim
export VISUAL=nvim

# Increase key speed via a rate change
xset r rate 300 50
source <(kubectl completion bash)
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

