#
# ~/.bashrc
#

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

# Increase key speed via a rate change
xset r rate 300 50
source <(kubectl completion bash)
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

export HADOOP_HOME=~/tools/hadoop-3.2.2
export HIVE_HOME=~/tools/apache-hive-2.3.9-bin
export JAVA_HOME=/usr/lib/jvm/default
export METALS_HOME=~/.local/share/coursier/bin
export PATH=$PATH:/home/ody/.local/bin:/home/ody/programming/aux/tools/bin:$HIVE_HOME/bin:/home/ody/tools:${METALS_HOME}

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

bind -x '"\C-f":tmux-sessionizer'
