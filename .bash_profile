# remove computer name from beginig on command line
# More about it:
# http://www.cyberciti.biz/tips/howto-linux-unix-bash-shell-setup-prompt.html
export PS1="$ "

# use nano as a default command line editor
export EDITOR="nano"

# enable bash autocompletion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# easier folders navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# why your mac is so slow?
alias top="top -o vsize"

# sudo autocomplete
complete -cf sudo

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
