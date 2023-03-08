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
export JAVA_HOME=/usr/lib/jvm/default
export METALS_HOME=~/.local/share/coursier/bin

export PATH=$PATH:/home/bournas/.local/bin:/home/ody/tools:${METALS_HOME}

# IMPORTANT: modify also the keyboard settings from KDE UI according to these values.
# Increase key speed via a rate change
xset r rate 300 50
