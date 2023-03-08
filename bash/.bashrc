#
# ~/.bashrc
#
# Put here anything that is strictly related to the BASH shell
#
#echo "~/.bashrc has been sourced"
unset LANG
source /etc/profile.d/locale.sh

set -o vi

export EDITOR=nvim
export VISUAL=nvim

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

if [[ $DISPLAY ]]; then
    # If not running interactively, do not do anything
    [[ $- != *i* ]] && return
    # Attach to a running tmux session or create a new one if none exists
    [[ -z "$TMUX" ]] && $(tmux attach || tmux)
fi


source <(kubectl completion bash)
#eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"

source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

#eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"

bind -x '"\C-f":tmux-sessionizer'

#source '/home/bournas/lib/azure-cli/az.completion'
