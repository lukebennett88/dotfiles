set -g fish_user_paths "/usr/local/sbin" $fish_user_paths

# No greeting
set fish_greeting

# Install Fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# Shorten `clear` command to `c`
function c
  clear $argv
end

# Show directory listing on directory change
function cd
  builtin cd $argv ; ls -lhA
end

# Open current directory in Finder
function f
  open -a finder ./ $argv
end

# Kill whichever port in inputted after `terminate` command
function terminate
  lsof -ti:$argv | xargs kill
end
