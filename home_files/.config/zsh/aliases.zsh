# Contains all user-defined aliases

# Directory navigation
alias ..='cd ..'					# Go up one directory
alias ...='cd ../..'			# Go up two directories
alias ....='cd ../../..'	# Go up three directories

# Common commands
alias c='clear'															# Clear the terminal screen
alias reload='source ~/.config/zsh/.zshrc'	# Reload zsh configuration

# Modern replacements for standard tools
alias cat='bat'																								# A 'cat' clone with syntax highlighting and git integration
alias ls="eza"																								# A modern replacement for ls
alias ll="eza --long --all --group-directories-first --icons"	# List all files with details and icons
alias tree="eza --tree"																				# List files in a tree-like structure

# Application shortcuts
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale" # Tailscale CLI

# Brewfile Aliases
alias binstall='brew bundle --file=~/.dotfiles/Brewfile'
alias bdump='brew bundle dump --force --file=~/.dotfiles/Brewfile'
alias bclean='brew bundle cleanup --force --file=~/.dotfiles/Brewfile'
