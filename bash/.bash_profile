#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export HADOOP_HOME=~/tools/hadoop-3.2.2
export HIVE_HOME=~/tools/apache-hive-2.3.9-bin
export JAVA_HOME=/usr/lib/jvm/default
export METALS_HOME=~/.local/share/coursier/bin
export PATH=$PATH:/home/ody/programming/beat/beat-dropbox/scripts:$HIVE_HOME/bin:/home/ody/tools:${METALS_HOME}
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
