#
# ~/.profile
#
# This should contain non-bash related settings (e.g. PATH, alias, environment variables)
#
#echo "~/.profile has been sourced"

#export ARM_CLIENT_ID="618f3bb3-dd88-40e1-b41e-4cca47a372c9"
#export ARM_CLIENT_SECRET="qWw8Q~CNqrEz50hKxeekWf4ACe.jyWTRMbxWxbk6"
#export ARM_SUBSCRIPTION_ID="e394f50e-00d6-408e-b0c9-7195bf3b3fef"
#export ARM_TENANT_ID="c4654250-6a36-4014-9411-097f663ae5f4"

#export HADOOP_HOME=~/tools/hadoop-3.2.2
#export HIVE_HOME=~/tools/apache-hive-2.3.9-bin
export NVIM_APPNAME=modern-neovim

export JAVA_HOME=/usr/lib/jvm/default
export METALS_HOME=~/.local/share/coursier/bin
export TOOLS_HOME=~/programming/aux/tools/bin
export ALTIPLANO_TOOLS_DIR=~/programming/aux/altiplano-tools
export ALTIPLANO_SCRIPTS_DIR=~/programming/nokia/tools/altiplano-scripts
export KARAF_HOME=~/tools/apache-karaf-4.3.9
export ARTIFACTORY_IP=artifactory-espoo-fnms.int.net.nokia.com
export realuser=bournas
export M2_HOME=/opt/apache-maven-3.9.11
export INTELLIJ_HOME=/home/bournas/tools/idea-IU-253.30387.90
export DEVCONTAINTER_HOME=/home/bournas/code/tools/devcontainer
export MASON_PATH=$HOME/.local/share/modern-neovim/mason

# export M2_HOME=/opt/altiplano-maven

export PATH=$M2_HOME/bin:$PATH:/home/bournas/.local/bin:/home/ody/tools:${METALS_HOME}:/home/bournas/programming/nokia/ee-environment/boxes/common-box:$TOOLS_HOME:$KARAF_HOME/bin:$ALTIPLANO_TOOLS_DIR/bin:$ALTIPLANO_TOOLS_DIR/scripts:$ALTIPLANO_SCRIPTS_DIR/bin:$ALTIPLANO_SCRIPTS_DIR/scripts/0-dev-altiplano-installation:$ALTIPLANO_SCRIPTS_DIR/scripts/3-build-container:${INTELLIJ_HOME}/bin:${DEVCONTAINTER_HOME}:${MASON_PATH}/bin


export QT_QPA_PLATFORM=wayland

# IMPORTANT: modify also the keyboard settings from KDE UI according to these values.
# Increase key speed via a rate change
xset r rate 300 50

PATH="/usr/local/bin/:$PATH"
