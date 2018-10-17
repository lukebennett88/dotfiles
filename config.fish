# Install Fisher
if not functions -q fisher
    echo "Installing fisher for the first time..." >&2
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fisher
end

# Shorten `clear` command to `c`
function c
  clear $argv
end

# list content of directory upon cd-ing into it
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
