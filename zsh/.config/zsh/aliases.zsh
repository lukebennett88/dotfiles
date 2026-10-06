# Contains all user-defined aliases

# Directory navigation
alias ..='cd ..'					# Go up one directory
alias ...='cd ../..'			# Go up two directories
alias ....='cd ../../..'	# Go up three directories

# Common commands
alias c='clear'						# Clear the terminal screen
alias reload='exec zsh'		# Restart zsh to reload configuration

# Git shortcuts
alias gst='git status'
alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gd='git diff'
alias gds='git diff --staged'
alias gc='git commit --verbose'
alias gcmsg='git commit --message'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gf='git fetch'
alias gl='git pull'
alias gp='git push'
alias glog='git log --oneline --decorate --graph'

# Modern replacements for standard tools
alias cat='bat'																								# A 'cat' clone with syntax highlighting and git integration
alias ls="eza"																								# A modern replacement for ls
alias ll="eza --long --all --group-directories-first --icons"	# List all files with details and icons
alias tree="eza --tree"																				# List files in a tree-like structure
alias cc="claude --dangerously-skip-permissions"							# Run Claude Code in yolo mode

# Application shortcuts
# Tailscale CLI — only define when the app is actually installed
[[ -x "/Applications/Tailscale.app/Contents/MacOS/Tailscale" ]] && \
	alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# Brewfile Aliases
alias binstall='just --justfile "$HOME/.dotfiles/justfile" packages'
alias bapps='just --justfile "$HOME/.dotfiles/justfile" optional'
# Dump installed formulae to /tmp for review; does not rewrite the manifests.
alias bdump='brew bundle dump --force --no-vscode --file=/tmp/Brewfile.dump'
