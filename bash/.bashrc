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

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(direnv hook bash)"

source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

# do i need these? i can do the source ./bin/activate myself
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"
#eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"

bind -x '"\C-f":tmux-sessionizer'

#source '/home/bournas/lib/azure-cli/az.completion'

#export NVM_DIR="$HOME/.nvm"
# [-s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# https://neovim.io/doc/user/starting.html 
# this tells nvim to find the configuration in ~/.config/modern-neovim and NOT ~/.config/nvim which is the default one.
# the ~/.config/modern-neovim is copied with stow
export NVIM_APPNAME=modern-neovim

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# export JAVA_TOOL_OPTIONS="-Djdk.util.zip.disableZip64ExtraFieldValidation=true --add-opens=java.base/com.sun.crypto.provider=ALL-UNNAMED"

# required by anvgit
# export cloudName=OHN64
export cloudName=
export CSL=$(whoami)
export HOST_UID=$(id -u)
export HOST_GID=$(id -g)
export realuser=$(whoami)

alias minikube-start='minikube start driver=none --extra-config=kubelet.serialize-image-pulls=false --kubernetes-version v1.24.7'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# if [ "$IS_CONTAINER" = "true" ]; then
#     exec /bin/bash --rcfile ~/.bashrc_container
# fi
if [ "$IS_CONTAINER" = "true" ]; then
    exec /bin/bash --rcfile ~/.bashrc_container
fi
