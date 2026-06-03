# Contains all user-defined aliases

# Directory navigation
alias ..='cd ..'					# Go up one directory
alias ...='cd ../..'			# Go up two directories
alias ....='cd ../../..'	# Go up three directories

# Common commands
alias c='clear'												# Clear the terminal screen
alias reload='source $ZDOTDIR/.zshrc'	# Reload zsh configuration

# Modern replacements for standard tools
alias cat='bat'																								# A 'cat' clone with syntax highlighting and git integration
alias ls="eza"																								# A modern replacement for ls
alias ll="eza --long --all --group-directories-first --icons"	# List all files with details and icons
alias tree="eza --tree"																				# List files in a tree-like structure

# Application shortcuts
# Tailscale CLI — only define when the app is actually installed
[[ -x "/Applications/Tailscale.app/Contents/MacOS/Tailscale" ]] && \
	alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# Brewfile Aliases
alias binstall='brew bundle --file=~/.dotfiles/Brewfile'
# Snapshot what's installed to a scratch file for review — never clobbers the
# bootstrap Brewfile. Cherry-pick anything new into Brewfile.optional by hand.
alias bdump='brew bundle dump --force --no-vscode --file=/tmp/Brewfile.dump'
alias bclean='brew bundle cleanup --force --file=~/.dotfiles/Brewfile'
