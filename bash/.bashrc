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

#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# https://neovim.io/doc/user/starting.html 
# this tells nvim to find the configuration in ~/.config/modern-neovim and NOT ~/.config/nvim which is the default one.
# the ~/.config/modern-neovim is copied with stow
export NVIM_APPNAME=modern-neovim

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# required by anvgit
export realuser=bournas
export cloudName=OHN64
