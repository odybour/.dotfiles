#
# ~/.bash_profile
#
# Note ----------
# There are two types of shells, login and non-login
# Different files are sourced each time. 
# Uncomment the echo commands in .profile, .bash_profile, .bashrc and try opening a shell to see 
# this in practice. 
# To open a non-login shell: su -l ody
# To open a login shell: su -l ody --login
# ---------------

#echo "~/.bash_profile has been sourced"

if [ -f ~/.profile ]; then
    source ~/.profile
fi

if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi
