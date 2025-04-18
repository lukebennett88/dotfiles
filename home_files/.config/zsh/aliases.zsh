# Contains all user-defined aliases

# Directory navigation
alias ..='cd ..'																											# Go up one directory
alias ...='cd ../..'																									# Go up two directories
alias ....='cd ../../..'																							# Go up three directories

# Common commands
alias c='clear'																												# Clear the terminal screen
alias reload='source ~/.zshrc'																				# Reload zsh configuration

# Modern replacements for standard tools
alias cat='bat'																												# A 'cat' clone with syntax highlighting and git integration
alias ls="eza"																												# A modern replacement for ls
alias ll="eza --long --all --group-directories-first --icons"					# List all files with details and icons
alias tree="eza --tree"																								# List files in a tree-like structure

# Git aliases (in addition to those from OMZP::git)
alias gcf='git clean -fxd'																						# Remove untracked files and directories in git
alias gco='git checkout'																							# Shorthand for git checkout
alias gl='git pull'																										# Shorthand for git pull
alias gp='git push'																										# Shorthand for git push
alias gst='git status'																								# Shorthand for git status

# Application shortcuts
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale" # Tailscale CLI
